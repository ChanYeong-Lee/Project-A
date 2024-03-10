using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class KillTheBossQuest : QuestStep
{
    private int killCount = 0;
    private int completeCount = 1;

    private void Start()
    {
        Managers.Game.bear.onKill += BossKilled;
    }
    
    private void OnDisable()
    {
        Managers.Game.bear.onKill -= BossKilled;
    }

    private void BossKilled()
    {
        if(killCount < completeCount)
        {
            killCount++;
        }

        if (killCount == completeCount)
        {
            CompleteQuestStep();
        }
    }
    private void UpdateState()
    {
        string state = killCount.ToString();
        ChangeState(state);
    }
    protected override void SetQuestStepState(string state)
    {

    }
}
