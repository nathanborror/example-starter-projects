// @flow
import React from 'react';
import Relay from 'react-relay/classic';

class App extends React.Component {
  render() {
    return (
      <div>
        <h1>{this.props.me.name}</h1>
      </div>
    );
  }
}

export default Relay.createContainer(App, {
  fragments: {
    me: () => Relay.QL`
      fragment on Account {
        name
      }
    `,
  },
});
