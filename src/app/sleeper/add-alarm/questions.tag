<sleeper-alarms-add-questions>
    <header class="header-bar">
        <div class="pull-left">
            <h1 class="title">STIR - Sleeper</h1>
        </div>
    </header>
  <div class="content">
    <div class="padded-full">
       <form action="" onsubmit="{submitQuestions}">
           <div id="name-input">
                <label class="description">First, what's your name?</label>
                <input type="text" name="name" ref="name" required>
          </div>
           <div class="description">
                Please order the following by how relevant they are to you:
           </div>
           <div id="paragraphs">
                <ul ref="questions" id="sortable" class="list">
                  <li data-question-id="1" class="padded-list ui-state-default">
                  <i class="pull-left material-icons">reorder</i><span class="">I put other people’s needs before my own and value cooperation and harmony.
                 </span>
                  </li>
                  <li data-question-id="2" class="padded-list ui-state-default">
                  <i class="pull-left material-icons">reorder</i><span class="">I am determined and organized in my approach to life’s tasks and value hard work</span>
                  </li>
                  <li data-question-id="3", class="padded-list ui-state-default">
                  <i class="pull-left material-icons">reorder</i><span class="">i am stimulated by the company of others and value my relationships.
                  </span>
                  </li>
                  <li data-question-id="4" class="padded-list ui-state-default">
                  <i class="pull-left material-icons">reorder</i><span class="">I am sensitive to my environment and have a depth of emotional experiences. </span>
                  </li>
                  <li data-question-id="5" class="padded-list ui-state-default">
                  <i class="pull-left material-icons">reorder</i><span class="">I am drawn to experience a variety of activities and value creative exploration.</span>
                  </li>
                </ul>
           </div>
           <button class="btn primary raised" type="submit">Submit</button>
      </form>
      <img show="{loading}" src="/images/loading.gif"></img>
  </div>
  
 <style>
     sleeper-alarms-add-questions {
        #name-input {
             label {
                height: 20px;
             }
             input {
                height: 35px;
             }
             margin-bottom: 15px;
         }
         .list {
             li {
                 min-height: 60px;
                 display: flex;
                 line-height: unset;
                 align-items: center;
                 margin-bottom: 15px;

                 span {
                    margin-left: 10px;
                 }
             }
         }
        #paragraphs {
            margin-top: 15px;
            margin-bottom: 30px;
        }
     }
 </style>
 <script>
    this.on('mount', async () => {
        console.log("add-alarm-questions mounted");
        if (IS_CLIENT) {
          $( function() {
            $( "#sortable" ).sortable();
          } );
        }
    });

    this.on('unmount', () => {
        this.state.sleeper.off('alarm_created', this.onAlarmCreated);
    });

    async submitQuestions(e) {
        e.preventDefault();
        console.log("Submit questions!");
        let questions = $(this.refs.questions).find('li').toArray().map(dom => $(dom).data("question-id"));
        console.log(questions);
        /*
        try {
            this.state.sleeper.currentAlarm.analysis = 'questions';
            this.state.sleeper.currentAlarm.name = this.refs.name.value;
            if (!this.state.auth.user.name) {
                this.state.auth.setUserName(this.refs.name.value);
            }
            let analysisStatus = await this.state.sleeper.questionsAnalyze(
                {name: this.refs.name.value}            
            );
            console.log("Analysis status", analysisStatus);

            this.validateCheck();
        
        } catch (err) {
            console.log("Questions analyze error!", err);
            this.showError(err);
        }*/
    }

    validateCheck() {
        if (!this.state.auth.user.status.phoneValidated) {
            if (IS_CLIENT) {
                page("/sign-up/contact")
            }
        } else if (!this.state.auth.user.pronoun) {
            if (IS_CLIENT) {
                page("/sign-up/pronoun")
            }
        }
        else {
            this.state.sleeper.addAlarm();
        }
    }
 </script>
</sleeper-alarms-add-questions>
