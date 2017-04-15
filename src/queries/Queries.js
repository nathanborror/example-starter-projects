// @flow
import Relay from 'react-relay/classic';

export default {
  me: () => Relay.QL`query { me }`,
};
