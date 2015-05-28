/*
 * Empty object to store all functions
 */
$.rest = new Object();

/*
 * Performs a GET request for the given url with the given params.
 * @param url: The url which should be requested
 * @param params: An array with all parameters that should be supplied as URL parameters
 * @param callback: A function with one parameter which will be called after complition. 
 * The recieved data will be passed as argument.
 */
$.rest.get = function(url, params, callback) {
  $.rest.send(url, 'GET', params, callback);
  
}

/*
 * Performs a POST request for the given url with the given params.
 * @param url: The url which should be requested
 * @param params: An array with all parameters that should be supplied as URL parameters
 * @param callback: A function with one parameter which will be called after complition. 
 * The recieved data will be passed as argument.
 * @param data: The data that should be send as POST data to the server
 */
$.rest.post = function(url, params, callback, data) {
  $.rest.send(url + "?" +  $.param(params), 'POST', data, callback);
  
}

/*
 * Performs a PUT request for the given url with the given params.
 * @param url: The url which should be requested
 * @param params: An array with all parameters that should be supplied as URL parameters
 * @param callback: A function with one parameter which will be called after complition. 
 * The recieved data will be passed as argument.
 * @param data: The data that should be send as PUT data to the server
 */
$.rest.put = function(url, params, callback, data) {
  $.rest.send(url + "?" +  $.param(params), 'PUT', data, callback);
  
}

/*
 * Performs a DELETE request for the given url with the given params.
 * @param url: The url which should be requested
 * @param params: An array with all parameters that should be supplied as URL parameters
 * @param callback: A function with one parameter which will be called after complition. 
 * The recieved data will be passed as argument.
 */
$.rest.delete = function(url, params, callback) {
  $.rest.send(url, 'DELETE', params, callback);
  
}

/*
 * Performs a HTTP request for the given url with the given params.
 * @param url: The url which should be requested
 * @param method: One of GET, POST, PUT or DELETE
 * @param data: An array with all parameters that should be supplied as URL parameters on GET and DELETE or the POST or PUT data
 * @param callback: A function with one parameter which will be called after complition. 
 * The recieved data will be passed as argument.
 */
$.rest.send = function(url, method, data, callback) {
  $.ajax(url, {
    method: method,
    async: true,
    cache: false,
    data: data,
    success: function(received) {
      var answer = received;
      
      // Try to parse JSON if not already a object, fallback is to create a new answer with an error description
      if(typeof received !== 'object') {
        try {
          answer = JSON.parse(received);
        } catch(e) {
          answer = {success: false, err_no: -1, err_msg: e, raw: received};
        }

      }
      // Perform callback with answer
      callback(answer);
    },
    error: function(xhr, ajaxOptions, thrownError) {
      // Create an answer and perform callback
      var answer = {success: false, err_no: xhr.status, err_msg: xhr.statusText};
      callback(answer);
    }
  });
}