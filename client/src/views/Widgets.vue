<template>
  <div id="widgets-list" v-if="currentUser">
    <div
      class="widget-listing"
      v-for="(widget, index) in widgets"
      v-bind:key="index"
    >
      <div class="edit-widget">
        <b-icon icon="cash-stack" variant="success" @click="makeSale(widget)" />
        <span style="width: 10px" />
        <b-icon
          icon="pencil-square"
          variant="info"
          @click="editWidget(widget)"
        />
        <span style="width: 10px" />
        <b-icon
          icon="x-octagon-fill"
          variant="danger"
          @click="deleteWidget(widget.id)"
        />
      </div>
      <p>Name: {{ widget.name }}</p>
      <p>
        Value:
        {{
          (widget.value_in_cents / 100.0).toLocaleString("en-US", {
            style: "currency",
            currency: "USD",
          })
        }}
      </p>
      <p>Quantity: {{ widget.quantity }}</p>
      <p>Sales:</p>
      <div
        class="sale-container"
        v-for="(sale, index) in widget.sales"
        v-bind:key="index"
      >
        <p>quantity: {{ sale.quantity }}</p>
        <p>
          total sale:
          {{
            (sale.total_sale_in_cents / 100.0).toLocaleString("en-US", {
              style: "currency",
              currency: "USD",
            })
          }}
        </p>
      </div>
    </div>
    <h3 id="no-widget-message" v-if="widgets.length == 0">
      You currently have no widgets
    </h3>

    <b-form id="new-widget-form" v-if="showNewWidgetForm">
      <hr />
      <b-form-group label="Name: " label-for="widget-name-input">
        <b-form-input
          id="widget-name-input"
          v-model="newWidget.name"
          type="text"
        />
      </b-form-group>
      <b-form-group label="Value in cents: " label-for="widget-value-input">
        <b-form-input
          id="widget-value-input"
          v-model="newWidget.valueInCents"
          type="text"
        />
      </b-form-group>
      <b-form-group label="Quantity: " label-for="widget-quantity-input">
        <b-form-input
          id="widget-quantity-input"
          v-model="newWidget.quantity"
          type="text"
        />
      </b-form-group>
      <b-button @click="editMode ? updateWidget() : createNewWidget()">
        {{ editMode ? "Update Widget" : "Create Widget" }}
      </b-button>
      <hr />
    </b-form>

    <b-button
      :variant="showNewWidgetForm ? 'outline-danger' : 'outline-success'"
      @click="
        showNewWidgetForm = !showNewWidgetForm;
        editMode = false;
        clearNewWidgetForm();
      "
    >
      {{ showNewWidgetForm ? "Hide Form" : "New Widget" }}
    </b-button>
  </div>
</template>

<script>
export default {
  data() {
    return {
      showNewWidgetForm: false,
      editMode: false,
      newWidget: {
        name: "",
        valueInCents: 0,
        quantity: 0,
        id: null,
      },
    };
  },
  computed: {
    currentUser() {
      return this.$store.state.currentUser;
    },
    widgets() {
      return this.$store.state.widgets;
    },
    lastServerResponse() {
      return this.$store.state.lastServerResponse;
    },
  },
  methods: {
    clearNewWidgetForm() {
      this.newWidget = {
        name: "",
        valueInCents: 0,
        quantity: 0,
        id: null,
      };
    },
    async createNewWidget() {
      const numberOfWidgets = this.widgets.length;
      await this.$store.dispatch("createWidget", this.newWidget);

      if (numberOfWidgets == this.widgets.length) {
        this.$bvToast.toast(this.lastServerResponse, {
          title: "Error Creating New Widget",
          variant: "danger",
          toaster: "b-toaster-top-center",
        });
      }

      this.clearNewWidgetForm();
      this.showNewWidgetForm = false;
    },
    async deleteWidget(widgetId) {
      if (confirm("Are you sure you want to delete this widget?")) {
        await this.$store.dispatch("deleteWidget", widgetId);
      }
    },
    editWidget(widget) {
      this.editMode = true;
      this.newWidget = {
        name: widget.name,
        valueInCents: widget.value_in_cents,
        quantity: widget.quantity,
        id: widget.id,
      };
      this.showNewWidgetForm = true;
    },
    async updateWidget() {
      await this.$store.dispatch("updateWidget", this.newWidget);
      this.editMode = false;
      this.clearNewWidgetForm();
      this.showNewWidgetForm = false;
    },
    async makeSale(widget) {
      await this.$store.dispatch("makeSale", {
        widgetId: widget.id,
        quantity: prompt("how many " + widget.name + " did you sell?"),
      });
    },
  },
};
</script>

<style>
#no-widget-message {
  font-style: italic;
  font-size: 0.8rem;
  padding: 10px;
}
#new-widget-form {
  margin-right: auto;
  margin-left: auto;
  width: 50%;
}
.edit-widget {
  display: flex;
  justify-content: flex-end;
  padding-right: 10px;
}
.edit-widget > svg:hover {
  opacity: 70%;
  cursor: pointer;
}
.widget-listing {
  border: 1px solid black;
  border-radius: 5px;
  width: 50%;
  margin-right: auto;
  margin-left: auto;
  margin-bottom: 10px;
  padding-top: 10px;
}
.sale-container {
  border: 1px solid rgb(86, 180, 133);
  border-radius: 5px;
  margin: 10px;
}
</style>