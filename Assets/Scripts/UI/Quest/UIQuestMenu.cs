using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using TMPro;

public class UIQuestMenu : ContentElement
{
    private UISlot slotPrefab;
    private UISlot selectedSlot;

    [SerializeField] private RectTransform content;
    public UISlot SelectedSlot { get => selectedSlot; set => selectedSlot = value; }


    public Dictionary<string, UISlot> idToSlotMap = new();
    public List<UISlot> slots = new List<UISlot>();

    private void OnEnable()
    {
        UpdateQuestMenu();
        GameEventsManager.Instance.questEvents.onQuestStateChange += QuestStateChange;
    }

    private void OnDisable()
    {
        GameEventsManager.Instance.questEvents.onQuestStateChange -= QuestStateChange;
    }

    protected override void Awake()
    {
        base.Awake();
        CreateQuestSlot();
    }
    private void InitQuests()
    {

    }

    private void CreateQuestSlot()
    {
        foreach (UISlot slot in slots)
        {
            Managers.Pool.Push(slot.gameObject);
        }
        slots.Clear();
        int i = 0;
        foreach (Quest quest in QuestManager.Instance.QuestDic.Values)
        {
            UISlot slot = Managers.Resource.Instantiate("Prefabs/UI/QuestSlot", content, true).GetComponent<UISlot>();
            slot.transform.SetSiblingIndex(i++);
            slot.SlotType = SlotType.QuestMenu;
            Debug.Log($" 퀘스트 슬록슬롯 추가 : {slot.name}");
            slots.Add(slot);
            UpdateSlot(slot, quest);
        }

        selectedSlot = content.transform.GetComponentInChildren<UISlot>();
    }
    public void UpdateSlot(UISlot slot, Quest quest)
    {
        slot.Texts["NameText"].text = ($"{quest.questInfo.questName}");
    }

    private void UpdateQuestMenu()
    {
        //TODO: 퀘스트 상태 업데이트 될때마다 호출
        foreach (Quest quest in QuestManager.Instance.QuestDic.Values)
        {
            SetQuestInfo(quest);
        }
    }
    private void UpdateQuestInfo()
    {
        //TODO: 퀘스트 슬록 마우스 클릭 입력받을때 Info 업데이트
    }
    private void QuestLogTogglePressed()
    {

    }
    private void QuestStateChange(Quest quest)
    {
        SetQuestInfo(quest);
    }

    private void OnSelect()
    {

    }



    //Instruction에 넣을 정보들
    private void SetQuestInfo(Quest quest)
    {
        // quest name

        texts["NameText"].text = quest.questInfo.questName;

        // status
        texts["DescriptionText"].text =
            ($"퀘스트 내용 :        {quest.questInfo.description}\n\n " +
            $"필요레벨 :            {quest.questInfo.requirementPlayerLevel}\n\n" +
            $"완료까지 남은 퀘스트 : {quest.questInfo.questStepPrefabs.Length}\n\n" +
            $"퀘스트 상태 :         {quest.state.ToString()} \n");
        //foreach (QuestInfoSo prerequisiteQuestInfo in quest.questInfo.questPrerequisites)
        //{
        //    texts["DescriptionText"].text += prerequisiteQuestInfo.questName + "\n";
        //}

        // rewards
        texts["GoldLabelText"].text = ($"{quest.questInfo.goldReward}");
        texts["ExpLabelText"].text = ($"{quest.questInfo.expReward}");
    }
}
