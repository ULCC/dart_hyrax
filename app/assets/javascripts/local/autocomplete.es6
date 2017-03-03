export class Autocomplete {
    constructor() {
    }

    // This is the initial setup for the form.
    setup() {
        $('[data-autocomplete]').each((index, value) => {
            let selector = $(value)
            switch (selector.data('autocomplete')) {
                case "creator_resource_ids":
                    this.autocompleteCreator(selector);
                    break;
                case "funder":
                    this.autocompleteFunder(selector);
                    break;
                case "journal":
                    this.autocompleteFunder(selector);
                    break;
            }
        });
    }

    // attach an auto complete based on the field
    fieldAdded(cloneElem) {
        var $cloneElem = $(cloneElem);
        // FIXME this code (comparing the id) depends on a bug. Each input has an id and
        // the id is duplicated when you press the plus button. This is not valid html.
        if (/_creator_resource_ids$/.test($cloneElem.attr("id"))) {
            this.autocompleteCreator($cloneElem);
        }
        else if (/_funder$/.test($cloneElem.attr("id"))) {
            this.autocompleteFunder($cloneElem);
        }
        else if (/_journal$/.test($cloneElem.attr("id"))) {
            this.autocompleteJournal($cloneElem);
        }
    }

    autocompleteCreator(field) {
        var cre = require('local/autocomplete/creator');
        new cre.Creator(field, field.data('autocomplete-url'))
    }

    autocompleteFunder(field) {
        var fnd = require('local/autocomplete/funder');
        new fnd.Funder(field, field.data('autocomplete-url'))
    }

    autocompleteJournal(field) {
        var jnl = require('local/autocomplete/journal');
        new jnl.Journal(field, field.data('autocomplete-url'))
    }


}