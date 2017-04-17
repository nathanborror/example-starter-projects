// @flow
import React from 'react';
import {graphql} from 'react-apollo';
import gql from 'graphql-tag'

class App extends React.Component {

  static propTypes = {
    data: React.PropTypes.shape({
      loading: React.PropTypes.bool,
      error: React.PropTypes.object,
      me: React.PropTypes.object,
    }).isRequired,
  }

  render() {
    if (this.props.data.loading) {
      return <div>Loading...</div>
    }
    if (this.props.data.error) {
      return <div>Error occurred</div>
    }
    return (
      <div>
        <h1>Hello {this.props.data.me.name}</h1>
      </div>
    );
  }
}

const MeQuery = gql`
  query Me {
    me { name }
  }
`

const AppWithData = graphql(MeQuery)(App)

export default AppWithData;
