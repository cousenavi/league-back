(function() {
  window.templates = {
    error: function(errorText) {
      return "<div class=\"alert alert-danger\" role=\"alert\">" + errorText + "</div>";
    },
    popup: function(head, content, footer) {
      return "<div class=\"modal\">\n          <div class=\"modal-dialog\">\n            <div class=\"modal-content\">\n                <div class=\"modal-header\">\n                    <button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-hidden=\"true\">×</button>\n                    <h4 class=\"modal-title\">" + head + "</h4>\n                </div>\n                <div class=\"modal-body\">" + content + "</div>\n                <div class=\"modal-footer\">" + footer + "</div>\n            </div>\n          </div>";
    },
    hiddenModel: function(model) {
      var html, key, value;
      html = '';
      for (key in model) {
        value = model[key];
        html += "<input type='hidden' data-value='" + key + "' value='" + value + "'>";
      }
      return html;
    }
  };

  window.request = function(options) {
    return $.ajax({
      url: options.url,
      data: options.params || {},
      method: options.method || 'GET',
      success: options.success,
      error: options.error || function(error) {
        console.log(error);
        $('#container .alert-danger').remove();
        return $('#container').prepend(window.templates.error(error.responseText));
      }
    });
  };

  window.extractData = function($el) {
    var data;
    data = {};
    $el.find('[data-value]').each(function() {
      return data[$(this).attr('data-value')] = $(this).val();
    });
    $el.find('[data-collection]').each(function() {
      var key;
      key = $(this).attr('data-collection');
      data[key] = [];
      return $(this).find('[data-element]').each(function() {
        var obj;
        obj = {};
        $(this).find('[data-atom]').each(function() {
          return obj[$(this).attr('data-atom')] = $(this).val();
        });
        return data[key].push(obj);
      });
    });
    return data;
  };

  window.setCookie = function(name, value, options) {
    var cookie, key;
    if (options == null) {
      options = {};
    }
    value = encodeURIComponent(value);
    cookie = "" + name + "=" + value;
    for (key in options) {
      value = options[key];
      cookie += "; " + key + "=" + value;
    }
    return document.cookie = cookie;
  };

  window.getCookie = function(name) {
    var keyval, kv, kvs;
    kvs = (function() {
      var _i, _len, _ref, _results;
      _ref = document.cookie.split('; ');
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        keyval = _ref[_i];
        _results.push(keyval.split('='));
      }
      return _results;
    })();
    return ((function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = kvs.length; _i < _len; _i++) {
        kv = kvs[_i];
        if (kv[0] === name) {
          _results.push(kv[1]);
        }
      }
      return _results;
    })())[0];
  };

  window.sessionExpired = function() {
    localStorage.setItem('user', null);
    return location.href = '/admin';
  };

  window.localStorageRead = function(key) {
    var val;
    val = localStorage.getItem(key);
    if ((val != null) && val !== 'undefined') {
      return JSON.parse(val);
    } else {
      return null;
    }
  };

}).call(this);
