<template>
  <div>
    <form novalidate class="md-layout" @submit.prevent="validateUser">
      <md-card class="md-layout-item md-size-50 md-small-size-100">
        <md-card-header>
          <div class="md-title">Users</div>
        </md-card-header>
        <md-card-content>
          <div class="md-layout md-gutter">
            <div class="md-layout-item md-small-size-100">
              <md-field :class="getValidationClass('firstName')">
                <label for="first-name">First Name</label>
                <md-input name="first-name" id="first-name" autocomplete="given-name" v-model="form.firstName" :disabled="sending" />
                <span class="md-error" v-if="!$v.form.firstName.required">The first name is required</span>
                <span class="md-error" v-else-if="!$v.form.firstName.minlength">Invalid first name</span>
              </md-field>
            </div>
            <div class="md-layout-item md-small-size-100">
              <md-field :class="getValidationClass('lastName')">
                <label for="last-name">Last Name</label>
                <md-input name="last-name" id="last-name" autocomplete="family-name" v-model="form.lastName" :disabled="sending" />
                <span class="md-error" v-if="!$v.form.lastName.required">The last name is required</span>
                <span class="md-error" v-else-if="!$v.form.lastName.minlength">Invalid last name</span>
              </md-field>
            </div>
          </div>
        </md-card-content>
        <md-progress-bar md-mode="indeterminate" v-if="sending" />
        <md-card-actions>
          <md-button type="submit" class="md-primary" :disabled="sending">Create user</md-button>
        </md-card-actions>
      </md-card>
      <md-snackbar :md-active.sync="userSaved">The user {{ lastUser }} was saved with success!</md-snackbar>
    </form>
    <md-card v-for="user in users" :key="user">
      <md-card-header>
        <div class="md-title">{{user}}</div>
      </md-card-header>

      <md-card-content>
        Lorem ipsum dolor sit amet, consectetur adipisicing elit. Optio itaque ea, nostrum odio. Dolores, sed accusantium quasi non.
      </md-card-content>

      <md-card-actions>
        <md-button>Action</md-button>
        <md-button>Action</md-button>
      </md-card-actions>
    </md-card>
  </div>
</template>

<script>
import { validationMixin } from 'vuelidate'
import {
  required,
  minLength
} from 'vuelidate/lib/validators'

import TruffleContract from 'truffle-contract'
import Career from '../../build/contracts/Career.json'
import Web3 from 'web3'

var web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:7545'))

// dirty hack for web3@1.0.0 support for localhost testrpc, see https://github.com/trufflesuite/truffle-contract/issues/56#issuecomment-331084530
if (typeof web3.currentProvider.sendAsync !== 'function') {
  web3.currentProvider.sendAsync = function () {
    return web3.currentProvider.send.apply(
      web3.currentProvider, arguments
    )
  }
}

var CareerContract = TruffleContract(Career)
CareerContract.setProvider(web3.currentProvider)
var meta, account, career

export default {
  name: 'FormValidation',
  mixins: [validationMixin],
  data: () => ({
    form: {
      firstName: null,
      lastName: null
    },
    userSaved: false,
    sending: false,
    lastUser: null,
    users: ["nobody"]
  }),
  validations: {
    form: {
      firstName: {
        required,
        minLength: minLength(3)
      },
      lastName: {
        required,
        minLength: minLength(3)
      }
    }
  },
  methods: {
    getValidationClass (fieldName) {
      const field = this.$v.form[fieldName]

      if (field) {
        return {
          'md-invalid': field.$invalid && field.$dirty
        }
      }
    },
    clearForm () {
      this.$v.$reset()
      this.form.firstName = null
      this.form.lastName = null
    },
    saveUser () {
      this.sending = true
      var firstName = this.form.firstName
      console.log(firstName)

      var meta, data, c = this

      web3.eth.getAccounts((error, accounts) => {
      if (error) {
        console.log(error)
        return
      }
      web3.eth.defaultAccount = account = accounts[0]

      CareerContract.deployed()
      .then(function(instance) {
        meta = instance
        firstName = firstName
       // return meta.addPerson.call(firstName)
        return meta.addPerson(firstName, {
          from: account
        }).then(function (result) {
          console.log(result)
        })

      }).then(function (result) {
        console.log(result)
        return meta.getPerson.call({
          from: account
        }).then(function (result) {
          c.users =result
        })


      }).then(function (result) {
        console.log(result)
      

      }).catch(function(err) {
        console.log(err)
        // There was an error! Handle it.
      });

      this.sending = false

    })

      // alert(firstName)
      // // career.addPerson.call(firstName).then(function (results) {
      // //   console.log(results)
      // // })
      // console.log(career.address)
      // CareerContract.at(career.address).then(function (instance) {
      //   meta = instance
      //   //return meta.addPerson.call(firstName)
      // }).then(function (person) {
      //   // If this callback is called, the call was successfully executed.
      //   // Note that this returns immediately without any waiting.
      //   return meta.addPerson.call(firstName);

      // }).catch(function (e) {
      //   console.log(e)
      //   // There was an error! Handle it.
      // })
      // // Instead of this timeout, here you can call your API
      // this.sending = false


    },
    validateUser () {
      this.$v.$touch()

      alert('aaa')

      if (!this.$v.$invalid) {
        this.saveUser()
      }
    },
    updateUsers (users) {
      this.users = users;
      this.$nextTick();
    }
  }
}
</script>

<style scoped>
  .md-progress-bar {
    position: absolute;
    top: 0;
    right: 0;
    left: 0;
  }
</style>
