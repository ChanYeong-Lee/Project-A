using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class QuestStep : MonoBehaviour
{

    private bool isCompleted = false;

    protected void CompleteQuestStep()
    {
        if (!isCompleted)
        {
            isCompleted = true;

            //Advance the quest forward now that we've finished this step
            Destroy(this.gameObject);
        }
    }
}
