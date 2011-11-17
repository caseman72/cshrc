javascript <<EOS

  //////
  //
  ////\/   goRun
  //  /\
  function goRun( step )
  {
    var goTest = new GOTest(window.name.toString());
    step = step || goTest.step;
    if(! step ) return;
    goTest.setStep(step, false);

    var url = buffer.URL;
    var file = content.document.location.pathname.split("/").pop() || "[No Name]";
    goTest.logLog( "url = " + url, 1);

    goTest.logStep( "Step = " + step, 0);
    switch( step )
    {
      case "restart":
      case "start":
        if( url != goTest.startUrl)
        {
          if( goTest.loop > 4)
          {
            goTest.logFail("bad startUrl [end]");
            goRun("end");
          }
          else
          {
            goTest.incrLoop();
            liberator.load( goTest.startUrl );
          }
        }
        else
        {
          goTest.setRuns( liberator.eval("("+ $('pre').text() +")") );
          if( goTest.runs.length == 0 )
          {
            if( goTest.loop > 4)
            {
              goTest.logFail("no runs found [end]");
              goRun("end");
            }
            else
            {
              goTest.incrLoop();
              tabs.reload(getBrowser().mCurrentTab, false);
            }
          }
          else
          {
            goTest.setStep("searchUrl", true);
            liberator.open( goTest.searchUrl );
          }
        }
        break;

      case "searchUrl":
        if( url != goTest.searchUrl)
        {
          if( goTest.loop > 4)
          {
            goTest.logFail("bad searchUrl [end]");
            goRun("end");
          }
          else
          {
            goTest.incrLoop();
            liberator.load( goTest.searchUrl );
          }
        }
        else if( goTest.runs.length == 0 )
        {
          goTest.setStep("restart", true);
          liberator.open( goTest.startUrl );
        }
        else
        {
          var run = goTest.runs[0];
          var q = run.url.replace(/^http:\/\/www.google.com\/search[?]q=/, "").replace(/[+]/g, " ");
              q = unescape( q );

          $("input[name='q']").val( q );
          if( $("input[name='q']").val() == q )
          {
            goTest.setStep("searchResults", true);
            $("input[name='btnG']").each( function() { buffer.followLink( this, 1 ) } );
          }
          else
          {
            if( goTest.loop > 4)
            {
              goTest.logFail("bad q [end]");
              goRun("end");
            }
            else
            {
              goTest.incrLoop();
              tabs.reload(getBrowser().mCurrentTab, false);
            }
          }
        }
        break;

      case "searchResults":
        if( $('h1:first').text().match(/We.*re sorry\.\.\./) )
        {
          if( $("#captcha").is("input") )
          {
            goTest.logPass("captcha present");
            goTest.setStep("end");
            liberator.open( goTest.captchaUrl );
          }
          else
          {
            goTest.logFail("We're sorry... [captcha]");
            goTest.setStep("captcha");
            liberator.open( goTest.searchUrl );
          }
        }
        else
        {
          goTest.setStep("dataUrl", true); // saves
          var html = $('ol:last').html() || '';
          if(! html.match(/^[<][!]--m--[>]/))
          {
            // html = $('ol:contains("Yellow Pages")').html() || '';
            html = $('ol:contains("White Pages")').html() || '';
          }
          if(! html.match(/^[<][!]--m--[>]/) && ! html.match(/^[<]li[>][<]p[>]/) )
          {
            html = $('ol:contains("<!--m-->")').html() || '';
          }
          goTest.setResults( html ); // saves
          liberator.open( goTest.dataUrl );
        }
        break;

      case "dataUrl":
        var run = goTest.runs.shift();
        goTest.setStep("dataResults", true); // saves

        $("input[name='city']").val(run.city);
        $("input[name='st']").val(run.st);
        $("textarea[name='data']").val(goTest.results);
        $("button[type='submit']").each( function() { buffer.followLink( this, 1 ) } );
        break;

      case "dataResults":
        goTest.setResults( "" );
        if( goTest.runs.length == 0 )
        {
          goTest.setStep("restart", true);
          liberator.open( goTest.startUrl );
        }
        else
        {
          goTest.setStep("searchUrl", true);
          liberator.open( goTest.searchUrl );
        }
        break;

      case "captcha":
        goClearCookies();  // use menus here

        var qs = ["Cars for sale", "Auto Loans", "Pharmacy rx Drugs", "Real Estate Mortgage",
                  "Motor Bikes", "NFL Salaries", "Girls Gone Wild", "World Poker Tour",
                  "Obama Press Conference", "Westminster Dog Show"];
        var q = qs[Math.floor(Math.random() * qs.length)];

        $("input[name='q']").val( q );
        if( $("input[name='q']").val() == q )
        {
          goTest.setStep("captchaResults", false);
          $("input[name='btnG']").each( function() { buffer.followLink( this, 1 ) } );
        }
        else
        {
          goTest.logFail("captch failed [end]");
          goRun("end");
        }
        break;

      case "captchaResults":
        if( $('h1:first').text().match(/We.*re sorry\.\.\./) )
        {
          if(goTest.loop == 5)
          {
            goTest.incrLoop();
            goTest.logFail("We're sorry... [captcha]");
            goTest.setStep("captcha");
            setTimeout( function(){liberator.open( "http://sorry.google.com/" )}, 10000);
          }
          else if(goTest.loop > 5)
          {
            goTest.logFail("5 tries to remove cookies");
            goTest.setStep("end");
            liberator.open( goTest.captchaUrl );
          }
          else if( $("#captcha").is("input") )
          {
            goTest.logPass("captcha present");
            goTest.setStep("end");
            liberator.open( goTest.captchaUrl );
          }
          else
          {
            goTest.incrLoop();
            goTest.logFail("We're sorry... [captcha]");
            goTest.setStep("captcha");
            setTimeout( function(){liberator.open( goTest.searchUrl )}, 10000);
          }
        }
        else
        {
          goTest.setStep("searchUrl", true); // saves
          liberator.open( goTest.searchUrl );
        }
        break;

      case "end":
        autocommands.remove("DOMLoad", goTest.searchUrlReg );
        autocommands.remove("PageLoad", goTest.searchUrlReg );
        autocommands.remove("LocationChange", goTest.searchUrlReg);
        autocommands.remove("DOMLoad", goTest.startUrlReg );

        // goClearCookies();
        break;
    }
  }


  //////
  //
  ////\/   goStartTests
  //  /\
  function goStartTests( )
  {
    var dataUrl = "http://www.yellowade.com/citypost/";
    var startUrl = "http://www.yellowade.com/zipjson/";
    var searchUrl = "http://www.google.com/";
    var captchaUrl = "http://www.yellowade.com/captcha/";

    window.name = "";
    var goTest = new GOTest();
        goTest.setDataUrl(dataUrl);
        goTest.setStartUrl(startUrl);
        goTest.setSearchUrl(searchUrl);
        goTest.setCaptchaUrl(captchaUrl);
        goTest.setStep("start", true);

    liberator.log ( "window name = " + window.name, 0);

    autocommands.add("DOMLoad", goTest.searchUrlReg , ":js var start = new Date().getTime(); while (new Date().getTime() < (start + 250)); goRun(); ");
    autocommands.add("PageLoad", goTest.searchUrlReg, ":js addjQuery()");
    autocommands.add("LocationChange", goTest.searchUrlReg, ":js addjQuery()");
    autocommands.add("DOMLoad", goTest.startUrlReg, ":js var start = new Date().getTime(); while (new Date().getTime() < (start + 250)); goRun(); ");

    // move to url
    liberator.open( goTest.startUrl );
  }

  //////
  //
  //  GoTest
  //
  //////
  var GOTestClass = {
    init: function(p) {
      $.extend(this, GOTestClass);
      if( typeof p != "undefined" ) {
        $.extend(true, this, liberator.eval("("+p+")"));
        this.results = unescape( this.results );
      }
    },

    save: function() {
      runs = "[";
      for( var i=0; i<this.runs.length; i++)
      {
        if( i == (this.runs.length-1) )
          runs = runs+"{url:\""+this.runs[i].url+"\",city:\""+this.runs[i].city+"\",st:\""+this.runs[i].st+"\"}";
        else
          runs = runs+"{url:\""+this.runs[i].url+"\",city:\""+this.runs[i].city+"\",st:\""+this.runs[i].st+"\"},";
      }
      runs = runs + "]";
      window.name = "{runs:"+runs+
                    ",dataUrl:\""+this.dataUrl+"\""+
                    ",dataUrlReg:\""+this.dataUrlReg+"\""+
                    ",startUrl:\""+this.startUrl+"\""+
                    ",startUrlReg:\""+this.startUrlReg+"\""+
                    ",searchUrl:\""+this.searchUrl+"\""+
                    ",searchUrlReg:\""+this.searchUrlReg+"\""+
                    ",captchaUrl:\""+this.captchaUrl+"\""+
                    ",captchaUrlReg:\""+this.captchaUrlReg+"\""+
                    ",step:\""+this.step+"\""+
                    ",results:\""+escape(this.results)+"\""+
                    ",loop:"+(this.loop ? this.loop : "0")+
                    ",log:\""+this.log+"\"}";
    },

    setDataUrl: function( url ) {
      this.dataUrl = url;
      this.dataUrlReg = url.replace( /^https*:\/\/www\./, "").replace( /^https*:\/\//, "" ).replace(/\./g, "[.]").replace(/\/.*$/, "");
      this.save();
    },

    setStartUrl: function( url ) {
      this.startUrl = url;
      this.startUrlReg = url.replace( /^https*:\/\/www\./, "").replace( /^https*:\/\//, "" ).replace(/\./g, "[.]").replace(/\/.*$/, "");
      this.save();
    },

    setSearchUrl: function( url ) {
      this.searchUrl = url;
      this.searchUrlReg = url.replace( /^https*:\/\/www\./, "").replace( /^https*:\/\//, "" ).replace(/\./g, "[.]").replace(/\/.*$/, "");
      this.save();
    },

    setCaptchaUrl: function( url ) {
      this.captchaUrl = url;
      this.captchaUrlReg = url.replace( /^https*:\/\/www\./, "").replace( /^https*:\/\//, "" ).replace(/\./g, "[.]").replace(/\/.*$/, "");
      this.save();
    },

    setStep: function( step, reset ) {
      if(reset)
        this.loop = 0;
      this.step = step;
      this.save();
    },

    setResults: function( results ) {
      this.results = results;
      this.save();
    },

    setRuns: function( runs ) {
      this.runs = runs;
      this.save();
    },

    incrLoop: function() {
      this.loop++;
      this.save();
    },

    logPass: function( str )
    {
      str = "Unit Test [pass]: " + str;
      liberator.log(str, 0);
      // this.log = this.log ? this.log + "<CR>" + str : str;
      this.save();
    },

    logFail: function( str )
    {
      str = "Unit Test [fail]: " + str;
      liberator.log(str, 0);
      // this.log = this.log ? this.log + "<CR>" + str : str;
      this.save();
    },

    logStep: function( str )
    {
      str = "Unit Test [step]: " + str;
      liberator.log(str, 0);
      // this.log = this.log ? this.log + "<CR>" + str : str;
      this.save();
    },

    logLog: function( str, level )
    {
      str = "Unit Test [log]: " + str;
      liberator.log(str, level);
      // this.log = this.log ? this.log + "<CR>" + str : str;
      this.save();
    },

    resetLog: function() {
      this.log = "";
      this.save();
    },

    // class members
    runs: new Array(),
    dataUrl: "",
    dataUrlReg: "",
    startUrl: "",
    startUrlReg: "",
    searchUrl: "",
    searchUrlReg: "",
    captchaUrl: "",
    captchaUrlReg: "",
    step: "",
    results: "",
    loop:0,
    log: ""
  };
  var GOTest = GOTestClass.init;


  //////
  //
  ////\/   goClearCookies
  //  /\
  function goClearCookies()
  {
    webdeveloper_clearSessionCookies();
    webdeveloper_deleteDomainCookies();
    webdeveloper_deletePathCookies();
  }

EOS
