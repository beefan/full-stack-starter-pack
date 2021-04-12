<template>
  <div id="app">
    <div id="nav">
      <router-link to="/">Home</router-link> |
      <router-link to="/about">About</router-link>
      <span v-if="loggedIn">
        | <router-link to="/widgets">Widgets</router-link> |
        <a id="logout-link" @click="logout">Logout</a>
      </span>
    </div>
    <Login v-if="!loggedIn" />
    <router-view />
  </div>
</template>

<script>
import Login from "./components/Login";

export default {
  data() {
    return {
      showLogin: true,
    };
  },
  components: { Login },
  computed: {
    loggedIn() {
      return this.$store.state.currentUser != null;
    },
  },
  methods: {
    async logout() {
      this.$store.dispatch("logoutUser");
      this.$bvToast.toast(`Goodbye!`, {
        variant: "primary",
        toaster: "b-toaster-top-center",
        autoHideDelay: 1500,
      });

      this.$router.push("/");
    },
  },
};
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

#logout-link {
  color: rgb(133, 133, 133);
}

#logout-link:hover {
  opacity: 80%;
  color: rgb(221, 101, 101);
  text-decoration: underline;
  cursor: pointer;
}

#nav {
  padding: 30px;
}

#nav a {
  font-weight: bold;
  color: #2c3e50;
}

#nav a.router-link-exact-active {
  color: #42b983;
}
</style>
