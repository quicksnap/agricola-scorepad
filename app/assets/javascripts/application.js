// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require handlebars
//= require ember
//= require ember-data
//= require_self
//= require agricola_score

// for more details see: http://emberjs.com/guides/application/
App = Ember.Application.create({
  // Basic logging, e.g. "Transitioned into 'post'"
  // LOG_TRANSITIONS: true,

  // Extremely detailed logging, highlighting every internal
  // step made while transitioning into a route, including
  // `beforeModel`, `model`, and `afterModel` hooks, and
  // information about redirects and aborted transitions
  // LOG_TRANSITIONS_INTERNAL: true
});

Ember.RSVP.configure('onerror', function(error) {
  Ember.Logger.assert(false, error);
});

App.ApplicationAdapter = DS.FixtureAdapter.extend();

// App.ApplicationAdapter = DS.FixtureAdapter;
//= require_tree .
