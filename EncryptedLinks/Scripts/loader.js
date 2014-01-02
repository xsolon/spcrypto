// loader: loads scripts sequentially
// When a script is loaded, all previous scripts are evaluated and objects declared available.
// version: 2.1
//  fix css regex
//  check if already registered 
/// usage: 
/*    
  var loader = xSolon.loader;
  
  // simple - script load
  loader.push('url here');
  
  // full syntax - script load
  // by passing a  function that return an object
  // you delay the evaluation of the load expression
  loader[loader.length] = function () {
   return {
    src: '//ajax.aspnetcdn.com/ajax/jQuery/jquery-1.9.1.min.js',
    load: (typeof $ == 'undefined')
   }
  ;};
  
  // this syntax is also delays evaluation of load as a function
  loader[loader.length] = {
  		src: '//ajax.aspnetcdn.com/ajax/jQuery/jquery-1.9.1.min.js',
  		load: function() { return (typeof $ == 'undefined');}
  	};
  
  // simple function load
  load.push(function(){ console.log('hi');});

  // Execute function
  loader[loader.length] = function () {
  	return {
  		func: function(){ alert('loaded'); },
  		load: false // won't be loaded cause load is false
  	};
  };
  

  // functions/scripts won't be loaded until loadAll 
  // or loadNext are called
  loader.loadAll();
*/
(function (ns) {
    "use strict";
    var w = window,
        udf = undefined,
        log = function (msg) {// simple logging function
            try {
                if (udf !== w.console) {
                    w.console.log('loader:' + msg);
                }
            } catch (ignore) { }
        },
        loader = [];// array to hold modules

    if (ns.loader) {
        log("already registered");
        return;
    }

    log("v2.1");

    // predefined script refs
    loader.suggestions = {
        'json2': { src: '//cdnjs.cloudflare.com/ajax/libs/json2/20121008/json2.min.js', load: !w.JSON },
        'jquery': { src: '//ajax.aspnetcdn.com/ajax/jQuery/jquery-1.10.2.min.js', load: function () { return !w.jQuery; } },
        'jqueryui': '//ajax.aspnetcdn.com/ajax/jquery.ui/1.10.3/jquery-ui.min.js',
        'jqueryuicss': '//ajax.aspnetcdn.com/ajax/jquery.ui/1.10.3/themes/dark-hive/jquery-ui.css',
        'xsolonxpath': { src: '//xsolonblog2.appspot.com/js/xpath.min.js', load: function () { return !ns.xPath; } },
        'xsolonstring': { src: '//xsolonblog2.appspot.com/js/string.js', load: function () { return !ns.string; } },
        'xonsole': { src: '//xsolonblog2.appspot.com/js/customconsole.js', load: true },
        'folding': { src: '//xsolonblog2.appspot.com/jsworkbench/folding.js', load: true },
        'sp': { src: "//xsolonblog2.appspot.com/js/sp.js", load: function () { return !ns.getFieldMap; } }
    };

    loader.require = function (js) {
        var module = loader.suggestions[js];
        if (module) {
            loader.push(module);
        }
        return module;
    };

    // Loads all remaining nodes
    loader.loadAll = function () {
        loader.loadNext(loader.loadAll);
    };

    loader.parseNode = function (n) {

        // parse node ---
        // will encapsulate node if needed
        if ('function' === typeof n && udf === n.func) {
            n = { func: n, load: true };
        } else if ('string' === typeof n) {
            n = { src: n, load: true };
        }

        // in the absence of load we assume load=true
        if (udf === n.load) {
            n.load = true;
        }
        // --------------

        // if .load is not a function wrap it
        if ('function' !== typeof n.load) {
            n.load = function () { return (n.load); };
        }

        return n;
    };

    // Loads next node in array
    // onNext: function to run when node is loaded
    loader.loadNext = function (onNext) {

        var n = this.shift(),
            next = function () {
                if (onNext !== null) { onNext(); }
            },
            doc = w.document,
            linkRef = null,
            script = null,
            scriptLoad;

        if (n && (udf !== n)) {
            n = loader.parseNode(n);

            if (n.load()) {
                if (udf !== n.func) {
                    n.func();
                    next();
                } else {

                    if (n.src.search('.css$') > 0) {

                        log("loading css: " + n.src);
                        linkRef = doc.createElement('link');
                        linkRef.rel = 'stylesheet';
                        linkRef.href = n.src;
                        linkRef.type = 'text/css';
                        doc.getElementsByTagName('head')[0].appendChild(linkRef);
                        next();

                    } else {

                        log("loading js script: " + n.src);
                        script = doc.createElement('script');
                        script.type = 'text/javascript';
                        script.src = n.src;

                        if (onNext !== null) {

                            scriptLoad = function () {
                                if (script.readyState === 'loaded' || script.readyState === 'complete' || udf === script.readyState) {
                                    next();
                                }
                            };

                            // attach event handler to script loaded event -------
                            if (udf !== script.readyState) { // others
                                script.onload = scriptLoad;
                            }
                            else {
                                script.onreadystatechange = scriptLoad; // IE
                            }
                            //----------------------------------------------------
                        }
                        doc.getElementsByTagName('head')[0].appendChild(script);
                    }
                }
            } else
                next();
        } else {
            log('done');
        }
    };

    // make public
    ns.loader = loader;

})(window.xSolon = window.xSolon || {});

