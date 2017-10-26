<sleeper-alarms-add-questions>
    <header class="header-bar">
        <div class="pull-left">
            <a href="/"><h1 class="title">STIR - Sleeper</h1></a>
        </div>
    </header>
  <div class="content">
    <div class="padded-full">
       <form action="" onsubmit="{submitQuestions}">
           <div class="description">
                <formatted-message id='QUESTIONS_DESCRIPTION'/>
           </div>
           <div id="name-input">
                <b><label><formatted-message id='QUESTIONS_NAME'/></label></b>
                <input type="text" name="name" ref="name" required>
          </div>
           <b><formatted-message id='QUESTIONS_ORDER'/></b>
           <div id="paragraphs">
                <ul ref="questions" id="sortable" class="list">
                  <li data-question-id="1" class="padded-list ui-state-default">
                  <i class="pull-left material-icons">reorder</i><formatted-message id='QUESTION_1'/>
                  </li>
                  <li data-question-id="2" class="padded-list ui-state-default">
                  <i class="pull-left material-icons">reorder</i><formatted-message id='QUESTION_2'/>
                  </li>
                  <li data-question-id="3", class="padded-list ui-state-default">
                  <i class="pull-left material-icons">reorder</i><formatted-message id='QUESTION_3'/>
                  </span>
                  </li>
                  <li data-question-id="4" class="padded-list ui-state-default">
                  <i class="pull-left material-icons">reorder</i><formatted-message id='QUESTION_4'/>
                  </li>
                  <li data-question-id="5" class="padded-list ui-state-default">
                  <i class="pull-left material-icons">reorder</i><formatted-message id='QUESTION_5'/>
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
             margin-bottom: 20px;
         }
         .list {
             li {
                 min-height: 60px;
                 display: flex;
                 line-height: unset;
                 align-items: center;
                 margin-bottom: 15px;
             }
         }
        #paragraphs {
            margin-top: 5px;
            margin-bottom: 30px;
            margin-right: 10px;
            margin-left: 5px;

        }
     }
 </style>
 <script>
    this.on('mount', async () => {
        console.log("add-alarm-questions mounted");
        this.state.sleeper.on('alarm_created', this.onAlarmCreated);
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
        console.log(questions,this.refs.name.value);
        try {
            let analysisStatus = await this.state.sleeper.questionsAnalyze(
                {
                    name: this.refs.name.value,
                    questions: questions
                }
            );
            console.log("Analysis status", analysisStatus);
            this.state.sleeper.currentAlarm.analysis = 'questions';
            this.state.sleeper.currentAlarm.name = this.refs.name.value;
            if (!this.state.auth.user.name) {
                this.state.auth.setUserName(this.refs.name.value);
            }

            this.validateCheck();
        
        } catch (err) {
            console.log("Questions analyze error!", err);
            phonon.alert(err.message, "Something went wrong", false, "Ok");
        }
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

    onAlarmCreated() {
        console.log("New alarm created!");
        if (IS_CLIENT) {
            page("/sleeper/alarms");
        }
    }
 </script>
</sleeper-alarms-add-questions>
