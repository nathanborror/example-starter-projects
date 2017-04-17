// @flow
import React from 'react';
import ReactDOM from 'react-dom';
import Relay from 'react-relay/classic';
import App from './components/App';

const config = {
  host: 'http://localhost:8080/graphql',
  authToken: 'Bearer YOUR_AUTH_TOKEN',
  mountNode: document.getElementById('root'),
}

Relay.injectNetworkLayer(
  new Relay.DefaultNetworkLayer(config.host, {
    headers: { Authorization: config.authToken },
  })
)

class HomeRoute extends Relay.Route {
  static routeName = 'Home'
  static queries = {
    account: () => Relay.QL`query { me }`
  }
}

ReactDOM.render(
  <Relay.RootContainer
    Component={App}
    route={new HomeRoute()}
  />,
  config.mountNode
);
