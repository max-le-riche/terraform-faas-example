module.exports.handler = async (event) => {
    console.log('Event: ', event)
  
    if (event.path === '/serverless_lambda_stage/') {
      return {
        statusCode: 200,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          message: 'Welcome',
        }),
      }
    } else {
      return {
        statusCode: 404,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          message: 'Route not found',
        }),
      }
    }
  }