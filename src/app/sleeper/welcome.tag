<sleeper-welcome>
<header class="header-bar">
    <div class="pull-left">
        <a href="/"><h1 class="title">STIR - Sleeper</h1></a>
    </div>
</header>
<div class="content">
     <div class="padded-full">
           <div class="row description">
                <formatted-message id='SLEEPER_WELCOME'/>
            </div>
           <div class="row explanation">
                <formatted-message id='SLEEPER_WELCOME_1'/>
            </div>
            <div class="how-works">
                <p><b><formatted-message id='HOW_IT_WORKS'/></b></p>
                <ul class="">
                  <li><formatted-message id='HOW_WORKS_1'/></li>
                  <li><formatted-message id='HOW_WORKS_2'/></li>
                  <li><formatted-message id='HOW_WORKS_3'/></li>
                  <li><formatted-message id='HOW_WORKS_4'/></li>
                </ul>
            </div>
            <div class="disclaimer">
                <formatted-message id='HOW_DISCLAMER_1'/>
                <a href="/faq"><formatted-message id='HOW_DISCLAMER_2'/></a>
                <formatted-message id='HOW_DISCLAMER_3'/>
            </div>
            <div class="action">
                <button class="btn raised primary" click="{begin}">
                    <formatted-message id='BEGIN'/>
                </a>
            </div>
      </div>
 </div>
 <style>
     sleeper-welcome {
         .description {
            font-size: 20px;
            margin-bottom: 10px;
         }

         .explanation {
            font-size: 16px;
            margin-bottom: 20px;
         
         }

         .action {
            display: flex;
            justify-content: center;
            margin-top: 20px;
         }
     }
 </style>
 <script>
    import MiscUtil from '../util/misc'

    this.on('mount', () => {
        console.log("sleeper welcome mounted");
    });

    this.on('unmount', () => {
    });

    this.on('ready', () => {
        this.update();
    });

    begin(e) {
        this.state.auth.shownSleeperIntro();
        page.show("/sleeper/alarms/add/time");
    }

 </script>
</sleeper-welcome>
