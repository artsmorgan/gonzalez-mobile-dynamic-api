import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import { describe, it } from "node:test";
import { canRevoke, describeDatabaseUrl, formatDbTarget, parseRevokeArgs } from "./revokeRefreshTokensArgs";

const BASE = { host: "h.example", port: "3306", name: "la_base" };

describe("argumentos del script de revocación de refresh tokens", () => {
    it("por defecto es un simulacro", () => {
        assert.deepEqual(parseRevokeArgs([]), { confirm: false, before: null, db: null });
        assert.equal(parseRevokeArgs(["--dry-run"]).confirm, false);
    });

    it("lee --confirm, --db y --before; rechaza lo desconocido y las fechas inválidas", () => {
        const a = parseRevokeArgs(["--confirm", "--db=la_base", "--before=2026-10-27T12:00:00Z"]);
        assert.equal(a.confirm, true);
        assert.equal(a.db, "la_base");
        assert.equal(a.before?.toISOString(), "2026-10-27T12:00:00.000Z");
        assert.throws(() => parseRevokeArgs(["--todo"]), /desconocido/);
        assert.throws(() => parseRevokeArgs(["--before=ayer"]), /fecha inválida/);
        assert.equal(parseRevokeArgs(["--db="]).db, null);
    });
});

describe("base de datos a la que apunta el script", () => {
    it("muestra servidor y nombre, nunca usuario ni contraseña", () => {
        const t = describeDatabaseUrl("mysql://usuario:clave-secreta@h.example:3306/la_base?x=1");
        assert.deepEqual(t, BASE);
        const texto = formatDbTarget(t!);
        assert.equal(texto, "h.example:3306/la_base");
        assert.doesNotMatch(texto, /usuario|clave-secreta/);
    });

    it("tolera comillas, puerto ausente y valores inválidos", () => {
        assert.deepEqual(describeDatabaseUrl('"mysql://u:p@h.example/otra"'), { host: "h.example", port: "", name: "otra" });
        for (const malo of [undefined, null, "", "no es una url", "mysql://h.example", "mysql://h.example/"]) assert.equal(describeDatabaseUrl(malo as never), null);
    });
});

describe("cuándo se permite revocar de verdad", () => {
    it("sin --confirm no revoca", () => {
        assert.equal(canRevoke(parseRevokeArgs([]), BASE).ok, false);
        assert.equal(canRevoke(parseRevokeArgs(["--db=la_base"]), BASE).ok, false);
    });

    it("con --confirm pero sin --db no revoca y dice a qué base apunta", () => {
        const d = canRevoke(parseRevokeArgs(["--confirm"]), BASE);
        assert.equal(d.ok, false);
        assert.match(d.ok ? "" : d.reason, /la_base/);
    });

    it("con un --db que no coincide no revoca (la base equivocada)", () => {
        const d = canRevoke(parseRevokeArgs(["--confirm", "--db=planillas_mirror"]), BASE);
        assert.equal(d.ok, false);
        assert.match(d.ok ? "" : d.reason, /no coincide/);
    });

    it("si no se puede leer DATABASE_URL no revoca", () => {
        assert.equal(canRevoke(parseRevokeArgs(["--confirm", "--db=la_base"]), null).ok, false);
    });

    it("solo revoca con --confirm y --db igual a la base", () => {
        assert.deepEqual(canRevoke(parseRevokeArgs(["--confirm", "--db=la_base"]), BASE), { ok: true });
        assert.deepEqual(canRevoke(parseRevokeArgs(["--confirm", "--db=la_base", "--before=2026-10-27T12:00:00Z"]), BASE), { ok: true });
    });
});

describe("el script", () => {
    const src = fs.readFileSync(path.join(__dirname, "..", "scripts", "revokeRefreshTokens.ts"), "utf8");
    it("imprime la base antes de contar y solo actualiza si canRevoke lo permite", () => {
        assert.ok(src.indexOf("Base de datos:") < src.indexOf("refresh_token.count"), "la base se muestra antes de contar");
        assert.ok(src.indexOf("canRevoke(") < src.indexOf("updateMany"), "la decisión va antes de modificar");
        assert.match(src, /if \(!decision\.ok\) \{[\s\S]*return;/);
    });
});
