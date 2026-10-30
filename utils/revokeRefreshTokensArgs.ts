/**
 * Argumentos y comprobaciones de `scripts/revokeRefreshTokens.ts` (issue #169 del monorepo): al desplegar la corrección se asume que los refresh
 * tokens pudieron quedar expuestos y se revocan todos. Es una acción con efecto sobre todos los guardas (tendrán que iniciar sesión de nuevo), así
 * que **por defecto no revoca nada**: solo cuenta. Para revocar hay que pasar `--confirm` Y `--db=<nombre de la base>`: el nombre debe coincidir con
 * la base a la que apunta `DATABASE_URL`, para que un script lanzado contra otra base (p. ej. la de otro servicio) no revoque en silencio donde no toca.
 * Módulo puro, sin Prisma, para poder probarlo.
 */
export type RevokeArgs = { confirm: boolean; before: Date | null; db: string | null };

export function parseRevokeArgs(argv: readonly string[]): RevokeArgs {
    let confirm = false;
    let before: Date | null = null;
    let db: string | null = null;
    for (const arg of argv) {
        if (arg === "--confirm") confirm = true;
        else if (arg === "--dry-run") confirm = false;
        else if (arg.startsWith("--before=")) {
            const d = new Date(arg.slice("--before=".length));
            if (Number.isNaN(d.getTime())) throw new Error(`fecha inválida en ${arg} (use ISO 8601, p. ej. 2026-10-27T12:00:00Z)`);
            before = d;
        } else if (arg.startsWith("--db=")) {
            db = arg.slice("--db=".length).trim() || null;
        } else {
            throw new Error(`argumento desconocido: ${arg}`);
        }
    }
    return { confirm, before, db };
}

export type DbTarget = { host: string; port: string; name: string };

/** Servidor y nombre de la base de una cadena de conexión, SIN usuario ni contraseña (para mostrarlos en pantalla). `null` si no se puede leer. */
export function describeDatabaseUrl(raw: string | undefined | null): DbTarget | null {
    const value = String(raw ?? "").trim().replace(/^["']|["']$/g, "");
    if (!value) return null;
    try {
        const u = new URL(value);
        const name = decodeURIComponent(u.pathname.replace(/^\//, ""));
        if (!u.hostname || !name) return null;
        return { host: u.hostname, port: u.port || "", name };
    } catch {
        return null;
    }
}

export const formatDbTarget = (t: DbTarget): string => `${t.host}${t.port ? `:${t.port}` : ""}/${t.name}`;

/** `reason` explica por qué no se revoca (solo cuando `ok` es false). */
export type ConfirmDecision = { ok: boolean; reason?: string };

/** ¿Se puede revocar de verdad? Solo con `--confirm` y con `--db` igual al nombre de la base a la que apunta `DATABASE_URL`. */
export function canRevoke(args: RevokeArgs, target: DbTarget | null): ConfirmDecision {
    if (!args.confirm) return { ok: false, reason: "Simulacro: no se revocó nada. Use --confirm --db=<nombre de la base> para revocar." };
    if (!target) return { ok: false, reason: "No se pudo leer DATABASE_URL: no se revoca nada." };
    if (!args.db) return { ok: false, reason: `Falta --db=<nombre de la base>. Esta ejecución apunta a «${formatDbTarget(target)}»; repita con --db=${target.name} si es la correcta.` };
    if (args.db !== target.name) return { ok: false, reason: `--db=${args.db} no coincide con la base a la que apunta DATABASE_URL («${target.name}»): no se revoca nada.` };
    return { ok: true };
}
