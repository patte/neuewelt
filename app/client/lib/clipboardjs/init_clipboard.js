function showTooltip(elem, msg) {
    elem.setAttribute('data-toggle', "tooltip")
    elem.setAttribute('data-placement', "bottom")
    elem.setAttribute('title', msg)
    $('[data-toggle=tooltip]').tooltip('show')
    elem.addEventListener('mouseleave', removeTooltip);
}

function removeTooltip(e) {
  elem = $(e.currentTarget).tooltip('destroy');
  e.currentTarget.removeAttribute('data-toggle');
  e.currentTarget.removeAttribute('data-placement');
  e.currentTarget.removeAttribute('data-original-title');
  e.currentTarget.removeAttribute('title');
  e.currentTarget.removeEventListener('mouseleave', removeTooltip);
}

// Simplistic detection, do not use it in production
function fallbackMessage(action) {
    var actionMsg = '';
    var actionKey = (action === 'cut' ? 'X' : 'C');

    if(/iPhone|iPad/i.test(navigator.userAgent)) {
        actionMsg = 'No support :(';
    }
    else if (/Mac/i.test(navigator.userAgent)) {
        actionMsg = 'Press ⌘-' + actionKey + ' to ' + action;
    }
    else {
        actionMsg = 'Press Ctrl-' + actionKey + ' to ' + action;
    }

    return actionMsg;
}

Meteor.startup(function() {
  var clipboardTriggers;
  clipboardTriggers = new Clipboard('[data-clipboard]');
  clipboardTriggers.on('success', function(e) {
    e.clearSelection();
    showTooltip(e.trigger, 'Copied!');
  });
  return clipboardTriggers.on('error', function(e) {
    showTooltip(e.trigger, fallbackMessage(e.action));
  });
});
