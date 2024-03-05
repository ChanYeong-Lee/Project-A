using System.Collections;
using System.Collections.Generic;
using System.Threading;
using Unity.PlasticSCM.Editor.WebApi;
using UnityEngine;

public class CollectWoodQuestStep : QuestStep
{
    private int woodsCollected = 0;
    private int woodsToComplete = 5;

    private void OnEnable()
    {
        GameEventsManager.Instance.miscEvents.onWoodCollected += WoodCollected;
    }
    private void OnDisable()
    {
        GameEventsManager.Instance.miscEvents.onWoodCollected -= WoodCollected;
    }

    private void WoodCollected(int count)
    {
        if (woodsCollected < woodsToComplete)
        {
            woodsCollected += count;
            UpdateState();
        }
        if (woodsCollected >= woodsToComplete)
        {
            CompleteQuestStep();
        }
    }

    private void UpdateState()
    {
        string state = woodsCollected.ToString();
        ChangeState(state);
    }

    protected override void SetQuestStepState(string state)
    {
        this.woodsCollected = System.Int32.Parse(state);
        UpdateState();
    }
}
 