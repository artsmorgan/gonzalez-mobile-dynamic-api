/**
 * Revoca los refresh tokens vigentes de la API dinámica (issue #169 del monorepo, «rotación al desplegar»). Aquí viven `refresh_token` y las rutas
 * de inicio de sesión, refresco y cierre de sesión, así que esta es la base que hay que revocar.
 *
 *   npx tsx scripts/revokeRefreshTokens.ts                                      → simulacro: muestra la base y CUENTA lo que revocaría (no cambia nada)
 *   npx tsx scripts/revokeRefreshTokens.ts --confirm --db=<nombre de la base>   → revoca todos los vigentes
 *   npx tsx scripts/revokeRefreshTokens.ts --confirm --db=<base> --before=<ISO> → revoca solo los creados antes de esa fecha
 *
 * Efecto: cada guarda deberá iniciar sesión de nuevo cuando venza su token de acceso (hasta 1 día). Coordinar el momento con el cliente y avisar a
 * soporte ANTES de ejecutarlo con `--confirm`. Usa la conexión de `DATABASE_URL` de ESTE proyecto; el script imprime servidor y nombre de la base (sin
 * credenciales) y exige que `--db` coincida con ese nombre, para no revocar en una base distinta de la que usan las sesiones.
 */
import { prisma } from "../utils/prismaClient";
import { canRevoke, describeDatabaseUrl, formatDbTarget, parseRevokeArgs } from "../utils/revokeRefreshTokensArgs";

async function main() {
    const args = parseRevokeArgs(process.argv.slice(2));
    const target = describeDatabaseUrl(process.env.DATABASE_URL);
    console.log(`Base de datos: ${target ? formatDbTarget(target) : "(no se pudo leer DATABASE_URL)"}`);

    const now = new Date();
    const where = { revoked: false, ...(args.before ? { createdAt: { lt: args.before } } : {}) };
    const [total, sinVencer] = await Promise.all([
        prisma.refresh_token.count({ where }),
        prisma.refresh_token.count({ where: { ...where, expiresAt: { gt: now } } }),
    ]);
    console.log(`Refresh tokens sin revocar${args.before ? ` creados antes de ${args.before.toISOString()}` : ""}: ${total} (de ellos, sin vencer: ${sinVencer})`);

    const decision = canRevoke(args, target);
    if (!decision.ok) {
        console.log(decision.reason ?? "No se revoca nada.");
        return;
    }
    const result = await prisma.refresh_token.updateMany({ where, data: { revoked: true } });
    console.log(`Revocados: ${result.count}`);
    const restantes = await prisma.refresh_token.count({ where: { ...where, expiresAt: { gt: new Date() } } });
    console.log(`Sin revocar y sin vencer después de revocar: ${restantes}`);
}

main()
    .catch((e) => {
        console.error(e instanceof Error ? e.message : e);
        process.exitCode = 1;
    })
    .finally(() => prisma.$disconnect());
