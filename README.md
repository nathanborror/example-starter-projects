# Starter Projects

These are meant to be very simple setups to act as starting off points for
prototyping new ideas.

All GraphQL examples are assuming the following schema:

    type Account {
        name: String!
    }
    type Query {
        me(): Account!
    }
    schema {
        query: Query
    }
