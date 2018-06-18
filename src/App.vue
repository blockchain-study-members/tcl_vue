<template>
  <div id="app">
    <img src="./assets/logo.png">
    <router-view/>
    <Register/>
    <!-- <UserList v-bind:instanceId="instanceId"/> -->
  </div>
</template>

<script>
import Register from './components/Register.vue'
import UserList from './components/UserList.vue'

export default {
  name: 'App',
  components: {
    Register,
    UserList
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
