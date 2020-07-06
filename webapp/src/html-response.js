module.exports = function htmlResponse(body) {
  return {
    statusCode: 200,
    body: body,
    headers: {
      'Content-Type': 'text/html'
    }
  };
};
