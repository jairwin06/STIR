<rouser-alarm-thankyou>
<header class="header-bar">
    <div class="pull-left">
        <a href="/"><h1 class="title">STIR - Rouser</h1></a>
    </div>
</header>
<div class="content">
    <div class="padded-full">
       <div class="row description">
          <b>Thank you!</b>
       </div>
       <div class="row explanation">
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
        .description {
            margin-bottom: 10px;
            font-size: 20px;
        }
        .explanation {
            p {
                font-size: 16px;
            }
            margin-bottom: 20px;
        }

        .action {
            display: flex;
            button {
               margin-right: 20px;

            }
        }

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
