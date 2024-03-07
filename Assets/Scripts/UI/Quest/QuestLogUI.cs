using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class QuestLogUI : MonoBehaviour
{
    [Header("Components")]
    [SerializeField] private GameObject contentParent;
    [SerializeField] private QuestScrolingList scrollingList;
    [SerializeField] private TextMeshProUGUI questDisplayNameText;
    [SerializeField] private TextMeshProUGUI questStatusText;
    [SerializeField] private TextMeshProUGUI goldRewardsText;
    [SerializeField] private TextMeshProUGUI experienceRewardsText;
    [SerializeField] private TextMeshProUGUI levelRequirementsText;
    [SerializeField] private TextMeshProUGUI questRequirementsText;

    private Button firstSelectedButton;

    private void OnEnable()
    {
        GameEventsManager.Instance.inputEvents.onQuestLogTogglePressed += QuestLogTogglePressed;
        GameEventsManager.Instance.questEvents.onQuestStateChange += QuestStateChange;
    }

    private void OnDisable()
    {
        GameEventsManager.Instance.inputEvents.onQuestLogTogglePressed -= QuestLogTogglePressed;
        GameEventsManager.Instance.questEvents.onQuestStateChange -= QuestStateChange;
    }

    private void QuestLogTogglePressed()
    {
        if (contentParent.activeInHierarchy)
        {
            HideUI();
        }
        else
        {
            ShowUI();
        }
    }

    private void ShowUI()
    {
        contentParent.SetActive(true);
        GameEventsManager.Instance.playerEvents.DisablePlayerMovement();
        // note - this needs to happen after the content parent is set active,
        // or else the onSelectAction won't work as expected
        if (firstSelectedButton != null)
        {
            firstSelectedButton.Select();
        }
    }

    private void HideUI()
    {
        contentParent.SetActive(false);
        GameEventsManager.Instance.playerEvents.EnablePlayerMovement();
        EventSystem.current.SetSelectedGameObject(null);
    }

    private void QuestStateChange(Quest quest)
    {
        // add the button to the scrolling list if not already added
        //QuestLogButton questLogButton = 
        //    scrollingList.CreateButtonIfNotExists(quest, () => {SetQuestLogInfo(quest);});

        // initialize the first selected button if not already so that it's
        // always the top button
        if (firstSelectedButton == null)
        {
            firstSelectedButton = questLogButton.button;
        }

        // set the button color based on quest state
        questLogButton.SetState(quest.state);
    }

    private void SetQuestLogInfo(Quest quest)
    {
        // quest name
        questDisplayNameText.text = quest.questInfo.questName;

        // status
        //questStatusText.text = quest.GetFullStatusText();

        // requirements
        levelRequirementsText.text = "Level " + quest.questInfo.requirementPlayerLevel;
        questRequirementsText.text = "";
        foreach (QuestInfoSo prerequisiteQuestInfo in quest.questInfo.questPrerequisites)
        {
            questRequirementsText.text += prerequisiteQuestInfo.questName + "\n";
        }

        // rewards
        goldRewardsText.text = quest.questInfo.goldReward + " Gold";
        experienceRewardsText.text = quest.questInfo.expReward + " XP";
    }
}
