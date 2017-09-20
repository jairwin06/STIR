export default {
    secret: process.env['AUTH_SECRET'],
    header: 'authorization',
    cookie : {
        enabled: true,
        name: 'STIR-jwt',
        secure: false
    },
    jwt: {
        audience: 'http://stir.com',
        issuer: 'STIR'
    }
}
