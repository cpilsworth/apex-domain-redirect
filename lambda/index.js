exports.handler = async (event, context) => {
    return {
        statusCode: 301,
        isBase64Encoded: false,
        headers: {
            Location: `https://www.${event.headers.host}${event.path}`
        }
    }
}