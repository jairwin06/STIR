export default {
    secret: 'takadanoSTIR',
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
