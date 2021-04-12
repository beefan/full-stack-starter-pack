async function postData(url = '', data = {}) {
  const response = await (fetch(url, {
    method: 'POST',
    mode: 'cors',
    cache: 'default',
    credentials: 'include',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(data)
  }));
  return response;
}

async function getData(url = '') {
  const response = await (fetch(url, {
    method: 'GET',
    mode: 'cors',
    credentials: 'include'
  }));
  return response;
}

module.exports = {
  postData,
  getData
}