using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class KillTheBossQuest : QuestStep
{
    private int killCount = 0;
    private int completeCount = 1;

   

    private void OneEnable()
    {
        GameEventsManager.Instance.miscEvents.onKillCount += BossKilled;
    }
    private void OnDisable()
    {
        GameEventsManager.Instance.miscEvents.onKillCount -= BossKilled;
    }

    private void BossKilled(int count)
    {
        if(killCount < completeCount)
        {
            killCount += count;
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
