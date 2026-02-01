// Not sure why this is an error, but in theory we just pull it all in.
// maybe it's a path thing?
// but, it would sure be nice to get all the community helpers!
// var helpers = require('handlebars-helpers);

Handlebars.registerHelper("concat", function(object, start, end, options) {
    name = start.trim() + end.trim();
    
    return options.lookupProperty(object, name);
});
