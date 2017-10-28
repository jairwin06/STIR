<rouser-alarms>
<header class="header-bar">
    <div class="pull-left">
        <a href="/"><h1>STIR | Rouser</h1></a>
    </div>
</header>
<div class="content">
     <div show="{state.rouser.alarms != null && state.rouser.alarms.length > 0}" class="padded-full">
            <h1><formatted-message id='ROUSER_FOUND_SLEEPER'/></h1>
            <p><formatted-message id='ROUSER_SLEEPER_EXPLANATION'/></p>
            <article class="sleeper" each={ state.rouser.alarms }>
                <div class="details">
                    <a href="/rouser/alarm/{_id}/record"><b>{name}</b></a>
                    <span>{country}</span>
                </div>
                <div>
                        <a href="/rouser/alarm/{_id}/record">
                            <button class="btn primary raised">
                            <formatted-message id="{'WAKE_' + pronoun}"/>
                            </button>
                        </a>
                </div>
            </article>
      </div>
     <div show="{state.rouser.alarms != null && state.rouser.alarms.length == 0}" class="padded-full">
            <h1><formatted-message id='ROUSER_NO_SLEEPERS'/></h1>
            <p><formatted-message id='ROUSER_NO_SLEEPERS_EXPLANATION'/></p>
      </div>
      <div show="{ state.rouser.alarms == null }" class="circle-progress center active">
        <div class="spinner"></div>
     </div>
 </div>
 <style>
     rouser-alarms {
         .description {
            font-size: 20px;
            margin-bottom: 10px;
         }
         .sleeper {
            background-color: #333;
            margin-top: 15px;
            padding: 20px;
            margin-right: 20px;
            display: flex;
            flex-direction: row;
            align-items: center;
            justify-content : space-between;

            .details {
                display: flex;
                flex-direction: column;
            }

            .btn {
                margin-top: 0;
            }
         }
     }
 </style>
 <script>
    import MiscUtil from '../util/misc'

    this.on('mount', () => {
        console.log("alarm-queue mounted");
        this.state.rouser.on('queue_updated', this.queueUpdated);
    });

    this.off('unmount', () => {
        this.state.rouser.on('queue_updated', this.queueUpdated);
    });

    this.on('ready', () => {
        this.update();
        if (!MiscUtil.isStandaone() && this.state.auth.user && !this.state.auth.user.status.suggestedRouserHome) {
            $('#home-suggest-message').html(
                this.formatMessage('HOME_SUGGEST', {
                    role: this.formatMessage('ROUSER')
                })
            );
            phonon.panel('#home-suggest').open();
            this.state.auth.suggestedRouserHome();
        }
        let manifestLink = $('link[href="manifest.json"]');
        if (manifestLink.length == 0) {
            $('head').append('<link rel="manifest" href="/rouser/manifest.json">');
        }
    });

    queueUpdated() {
        console.log("Queue updated");
        this.update();
    }

 </script>
</rouser-alarms>
