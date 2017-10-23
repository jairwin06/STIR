<sleeper-alarm-summary>
<header class="header-bar">
    <div class="pull-left">
        <a href="/"><h1 class="title">STIR</h1></a>
    </div>
</header>
<div class="content">
     <div class="padded-full">
           <div class="row description">
                <formatted-message id='SLEEPER_SUMMARY_DESCRIPTION' name="{state.auth.user.name}"/>
            </div>
            <div class="row explanation">
                <p><b>You Are:</b></p>
                <p each="{traits}">
                    {trait} : {value}
                </p>
            </div>
            <div class="action">
                <a class="btn raised primary" href="/rouser/alarms">
                    <formatted-message id='BE_A_ROUSER'/>
                </a>
            </div>
      </div>
 </div>
 <style>
     sleeper-alarm-summary {
         .description {
            font-size: 20px;
            margin-bottom: 10px;
         }
         .action {
            display: flex;
            justify-content: center;
            margin-top: 20px;
         }
     }
 </style>
 <script>

    this.traits = Object.keys(this.state.sleeper.currentAlarm.generatedFrom).map((key) => {
        return {trait: key, value: this.state.sleeper.currentAlarm.generatedFrom[key]}
    });
    this.on('mount', () => {
        console.log("alarm summary mounted");
    });

    this.on('unmount', () => {
    });

    this.on('ready', () => {
    });

 </script>
</sleeper-alarm-summary>
