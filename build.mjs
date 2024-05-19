import * as esbuild from 'esbuild'

await esbuild.build({
    entryPoints: ['js/app.js'],
    bundle: true,
    outfile: 'static/assets/app.js',
    loader: { '.svg': 'dataurl' }
})
