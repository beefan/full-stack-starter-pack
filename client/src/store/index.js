import Vue from "vue";
import Vuex from "vuex";
import fetchUtil from "./fetch-util";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    currentUser: null,
    lastServerResponse: ""
  },
  getters: {
    currentUser: state => {
      return state.currentUser
    },
    lastServerResponse: state => {
      return state.lastServerResponse
    }
  },
  mutations: {
    login(state, body) {
      if (body && body != undefined) state.currentUser = body
    },
    logout(state) {
      state.currentUser = null
    },
    updateServerResponse(state, body) {
      state.lastServerResponse = body
    }
  },
  actions: {
    async loginUser(_, loginParams) {
      const data = {
        userDetails: {
          username: loginParams.username,
          password: loginParams.password
        }
      }

      const res = await fetchUtil.postData(`${process.env.VUE_APP_API_HOST}/login`, data);
      const body = await res.json();
      this.commit('updateServerResponse', body);

      if (body.username) this.commit('login', body);
    },
    async signUpUser(_, signUpParams) {
      const data = {
        userDetails: {
          username: signUpParams.username,
          password: signUpParams.password,
          email: signUpParams.username
        }
      }

      const res = await fetchUtil.postData(`${process.env.VUE_APP_API_HOST}/signup`, data);
      const body = await res.json();
      this.commit('updateServerResponse', body);
    },
    async logoutUser() {
      const res = await fetchUtil.getData(`${process.env.VUE_APP_API_HOST}/logout`);
      const body = await res.json();
      this.commit('updateServerResponse', body);

      if (res.status == 200) this.commit('logout');
    }
  },
  modules: {},
});
