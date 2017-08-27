export default {
    secret: 'takadanoSTIR',
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
