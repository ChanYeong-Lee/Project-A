using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class QuestScrolingList : MonoBehaviour
{
    [Header("Components")]
    [SerializeField] private GameObject contentParent;

    [Header("Quest Log Button")]
    [SerializeField] private GameObject QuestSlotPrefab;

    [Header("Rect Transforms")]
    [SerializeField] private RectTransform scrollRectTransform;
    [SerializeField] private RectTransform contentRectTransform;

    public Dictionary<string, UIQuestSlot> idToSlotMap = new();

    private void Start()
    {
        for (int i = 0; i < 20; i++)
        {
            QuestInfoSo questInfoTest = ScriptableObject.CreateInstance<QuestInfoSo>();

            questInfoTest.questStepPrefabs = new GameObject[0];
            Quest quest = new Quest(questInfoTest);

            UIQuestSlot questLogButton = CreateButtonIfNotExists(quest, () =>
            {
                Debug.Log("SELECTED: " + questInfoTest.questName);
            });

            if (i == 0)
            {
                questLogButton.button.Select();
            }
        }
    }

    public UIQuestSlot CreateButtonIfNotExists(Quest quest, UnityAction selectAction)
    {
        UIQuestSlot questSlot = null;
        // only create the button if we haven't seen this quest id before
        if (!idToSlotMap.ContainsKey(quest.questInfo.id))
        {
            questSlot = InstantiateQuestLogButton(quest, selectAction);
        }
        else
        {
            questSlot = idToSlotMap[quest.questInfo.id];
        }
        return questSlot;
    }

    private UIQuestSlot InstantiateQuestLogButton(Quest quest, UnityAction selectAction)
    {
        //Create button
        UIQuestSlot uiQuestSlot = Instantiate(QuestSlotPrefab, contentParent.transform).GetComponent<UIQuestSlot>();

        uiQuestSlot.gameObject.name = $"{quest.questInfo.id}Button";

        uiQuestSlot.Initialized(quest.questInfo.questName, selectAction);

        // Add to keep track of the new slot
        idToSlotMap[quest.questInfo.id] = uiQuestSlot;
        return uiQuestSlot;
    }
    private void UpdateScrolling(RectTransform buttonRectTransform)
    {
        // calculate the min and max for the selected button
        float buttonYMin = Mathf.Abs(buttonRectTransform.anchoredPosition.y);
        float buttonYMax = buttonYMin + buttonRectTransform.rect.height;

        // calculate the min and max for the content area
        float contentYMin = contentRectTransform.anchoredPosition.y;
        float contentYMax = contentYMin + scrollRectTransform.rect.height;

        // handle scrolling down
        if (buttonYMax > contentYMax)
        {
            contentRectTransform.anchoredPosition = new Vector2(
                contentRectTransform.anchoredPosition.x,
                buttonYMax - scrollRectTransform.rect.height
            );
        }
        // handle scrolling up
        else if (buttonYMin < contentYMin)
        {
            contentRectTransform.anchoredPosition = new Vector2(
                contentRectTransform.anchoredPosition.x,
                buttonYMin
            );
        }

    }
}
