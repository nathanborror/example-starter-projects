// @flow
import React from 'react';
import Relay from 'react-relay/classic';

class App extends React.Component {
  render() {
    return (
      <div>
        <h1>{this.props.account.name}</h1>
        {this.props.account.followingShows}
      </div>
    );
  }
}

export default Relay.createContainer(App, {
  fragments: {
    account: () => Relay.QL`
        fragment on Account {
            name
        }
    `
  }
});
