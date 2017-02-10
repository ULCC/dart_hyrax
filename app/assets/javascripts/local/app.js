Local = {
    initialize: function () {
        this.autocomplete();
    },

    autocomplete: function () {
        var ac = require('local/autocomplete');
        var autocomplete = new ac.Autocomplete()
        $('.multi_value.form-group').manage_fields({
            add: function(e, element) {
                autocomplete.fieldAdded(element)
            }
        });
        autocomplete.setup();
    },

};