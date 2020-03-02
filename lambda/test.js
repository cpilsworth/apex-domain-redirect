const handler = require('./index').handler;

const event = {
    Records: [
        {
            cf: {
                request: {
                    uri: "/test",
                    headers: {
                        "host": [
                            {
                                key: "Host",
                                value: "diffa.co.uk"
                            }
                        ]
                    }
                }   
            }
        }
    ]
}

async function main() {
    const result = await handler(event, {});
    console.log(JSON.stringify(result));
}

main();