<template>
  <b-container>
    <b-form>
      <b-form-group label="Username: " label-for="username-input">
        <b-form-input
          id="username-input"
          v-model="form.username"
          type="text"
          :state="usernameValidation"
        />
        <b-form-invalid-feedback :state="usernameValidation">
          Username must be letters and numbers, 5-20 characters long
        </b-form-invalid-feedback>
      </b-form-group>
      <b-form-group label="Password: " label-for="password-input">
        <b-form-input
          id="password-input"
          v-model="form.password"
          type="password"
          :state="passwordValidation"
        />
        <b-form-invalid-feedback :state="passwordValidation">
          Password must be greater than or equal to 12 characters long
        </b-form-invalid-feedback>
      </b-form-group>
      <b-form-group
        v-if="!showLogin"
        label="Confirm Password: "
        label-for="confirm-password-input"
      >
        <b-form-input
          id="confirm-password-input"
          v-model="form.confirmPassword"
          :state="confirmPasswordValidation"
          type="password"
        />
        <b-form-invalid-feedback :state="confirmPasswordValidation">
          Passwords must match
        </b-form-invalid-feedback>
      </b-form-group>
      <b-button
        @click="loginOrSignUp"
        variant="dark"
        :disabled="disableButton"
        >{{ showLogin ? "Login" : "Create User" }}</b-button
      >
      <p>
        {{ showLogin ? "not yet signed up?" : "already signed up?" }}
        <a @click="showLogin = !showLogin">
          {{ showLogin ? "create an account" : "login" }}
        </a>
      </p></b-form
    >
  </b-container>
</template>

<script>
export default {
  data() {
    return {
      form: {
        username: "",
        password: "",
      },
    };
  },
  methods: {
    login() {
      // Perform Login
      console.log("login");
    },
  },
  computed: {
    usernameValidation() {
      if (this.form.username == "") return null;
      return (
        this.form.username.length > 4 &&
        this.form.username.length < 20 &&
        /^[a-z0-9]+$/i.test(this.form.username)
      );
    },
    passwordValidation() {
      if (this.form.password == "") return null;
      return this.form.password.length >= 12;
    },
    confirmPasswordValidation() {
      if (this.form.confirmPassword == "") return null;
      return this.form.password === this.form.confirmPassword;
    },
    emailValidation() {
      if (this.form.email == "") return null;
      return (
        this.form.email.indexOf("@") > -1 &&
        this.form.email.indexOf(".") > -1 &&
        this.form.email.split("@")[1].length > 3
      );
    },
    disableButton() {
      if (this.showLogin) {
        return !(this.usernameValidation && this.passwordValidation);
      }
      return !(
        this.usernameValidation &&
        this.passwordValidation &&
        this.emailValidation &&
        this.confirmPasswordValidation
      );
    },
  },
};
</script>

<style>
</style>