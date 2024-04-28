import React from "react";
import {
  Admin,
  Resource,
  ListGuesser,
  EditGuesser,
  ShowGuesser,
} from "react-admin";
import { dataProvider } from "./dataProvider";
import { PostList } from "./posts/PostList";
import { UserList } from "./posts/UserList";

export const App = () => (
  <Admin dataProvider={dataProvider}>
    <Resource
      name="users"
      list={UserList}
      recordRepresentation={"name"}
      edit={EditGuesser}
      show={ShowGuesser}
    />
    <Resource
      name="posts"
      list={PostList}
      edit={EditGuesser}
      show={ShowGuesser}
    />
  </Admin>
);
