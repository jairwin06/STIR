<rouser-alarms>
<header class="header-bar">
    <div class="pull-left">
        <a href="/"><h1 class="title">STIR - Rouser</h1></a>
    </div>
</header>
<div class="content">
     <div show="{state.rouser.alarms != null && state.rouser.alarms.length > 0}" class="padded-full">
           <div class="row description">
                <formatted-message id='ROUSER_FOUND_SLEEPER'/>
            </div>
           <div class="row explanation">
                <formatted-message id='ROUSER_SLEEPER_EXPLANATION'/>
            </div>
            <article class="sleeper" each={ state.rouser.alarms }>
                <div class="details">
                    <a href="/rouser/alarm/{_id}/record"><b>{name}</b></a>
                    <span>{country}</span>
                </div>
                <div class="action">
                        <a href="/rouser/alarm/{_id}/record">
                            <button class="btn primary raised">
                            <formatted-message id="{'WAKE_' + pronoun}"/>
                            </button>
                        </a>
                </div>
            </article>
      </div>
     <div show="{state.rouser.alarms != null && state.rouser.alarms.length == 0}" class="padded-full">
           <div class="row description">
                <formatted-message id='ROUSER_NO_SLEEPERS'/>
            </div>
           <div class="row explanation">
                <formatted-message id='ROUSER_NO_SLEEPERS_EXPLANATION'/>
            </div>
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
            background-color: #f9f9f9;
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
         }
     }
 </style>
 <script>
    this.on('mount', () => {
        console.log("alarm-queue mounted");
        this.state.rouser.on('queue_updated', this.queueUpdated);
    });

    this.on('unmount', () => {
    });

    this.on('ready', () => {
        this.update();
    });

    queueUpdated() {
        console.log("Queue updated");
        this.update();
    }

 </script>
</rouser-alarms>
