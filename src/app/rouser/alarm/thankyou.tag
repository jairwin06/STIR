<rouser-alarm-thankyou>
<header class="header-bar">
    <div class="pull-left">
        <a href="/"><h1>STIR | Rouser</h1></a>
    </div>
</header>
<div class="content">
    <div class="padded-full">
       <div class="row description">
          <h1>Thank you!</h1>
       </div>
       <div>
            <p>If you would like, we can search for another sleeper in need of a wakeup.</p>

            <p>Or you can be a sleeper yourself.</p>
       </div>
       <div class="action">
            <a href="/rouser/alarms">
                <button class="btn primary raised" click="{anotherSleeper}">
                    <formatted-message id="ANOTHER_SLEEPER"/>
                </button>
            </a>
            <a href="/sleeper/alarms">
                <button class="btn primary raised">
                <formatted-message id="BE_A_SLEEPER"/>
                </button>
            </a>
        </div>
    </div>
</div>

<style>
    rouser-alarm-thankyou {
    }
</style>
    <script>
        this.on('mount', () => {
                    
        });

        this.on('unmount', () => {

        });

        this.on('ready', () => {
        })
    </script>
</rouser-alarm-thankyou>
