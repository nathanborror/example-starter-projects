// @flow
import React from 'react';
import ReactDOM from 'react-dom';
import AppWithData from './components/App';

import ApolloClient, { createNetworkInterface } from 'apollo-client'
import { ApolloProvider } from 'react-apollo'

const networkInterface = createNetworkInterface(
  {uri: 'http://localhost:8080/graphql'},
)

networkInterface.use([{
  applyMiddleware(req, next) {
    if (!req.options.headers) {
      req.options.headers = {};
    }
    const token = 'YOUR_AUTH_TOKEN';
    req.options.headers.authorization = `Bearer ${token}`;
    next();
  }
}])

const client = new ApolloClient({
  networkInterface: networkInterface
})

ReactDOM.render(
  <ApolloProvider client={client}>
    <AppWithData />
  </ApolloProvider>,
  document.getElementById('root')
);
