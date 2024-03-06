using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Collider))]
public class VisitUnkwonWorldQuestStep : QuestStep
{

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            CompleteQuestStep();
        }
    }


    protected override void SetQuestStepState(string state)
    {
        //no state is needed for this quest step
    }

}
