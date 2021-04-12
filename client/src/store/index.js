import Vue from "vue";
import Vuex from "vuex";
import fetchUtil from "./fetch-util";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    currentUser: null,
    widgets: [],
    lastServerResponse: ""
  },
  getters: {
    currentUser: state => {
      return state.currentUser
    },
    lastServerResponse: state => {
      return state.lastServerResponse
    },
    widgets: state => {
      return state.widgets
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
    },
    setWidgets(state, widgets) {
      state.widgets = widgets
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

      if (body.username) {
        this.commit('login', body);
        this.commit('setWidgets', body.widgets);
      }
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
      this.commit('setWidgets', [])

      if (res.status == 200) this.commit('logout');
    },
    async reloadWidgets() {
      const res = await fetchUtil.getData(`${process.env.VUE_APP_API_HOST}/api/widgets`);
      const body = await res.json();
      if (res.status == 200) this.commit('setWidgets', body);
    },
    async createWidget(_, widgetParams) {
      const data = {
        widget_details: {
          name: widgetParams.name,
          value_in_cents: widgetParams.valueInCents,
          quantity: widgetParams.quantity
        }
      }

      const res = await fetchUtil.postData(`${process.env.VUE_APP_API_HOST}/api/widgets`, data);
      const body = await res.json();
      this.commit('updateServerResponse', body);
      await this.dispatch('reloadWidgets');
    },
    async updateWidget(_, widgetParams) {
      const data = {
        widget_details: {
          name: widgetParams.name,
          value_in_cents: widgetParams.valueInCents,
          quantity: widgetParams.quantity
        }
      }

      const res = await fetchUtil.putData(`${process.env.VUE_APP_API_HOST}/api/widgets/${widgetParams.id}`, data);
      const body = await res.json();
      this.commit('updateServerResponse', body);
      await this.dispatch('reloadWidgets');
    },
    async deleteWidget(_, widgetId) {
      const res = await fetchUtil.deleteData(`${process.env.VUE_APP_API_HOST}/api/widgets/${widgetId}`);
      const body = await res.json();
      this.commit('updateServerResponse', body);
      await this.dispatch('reloadWidgets');
    },
    async makeSale(_, params) {
      const data = {
        sale_details: {
          widget_id: params.widgetId,
          quantity: params.quantity
        }
      }
      const res = await fetchUtil.postData(`${process.env.VUE_APP_API_HOST}/api/sales`, data);
      const body = await res.json();
      this.commit('updateServerResponse', body);
      await this.dispatch('reloadWidgets');
    }
  },
  modules: {},
});
