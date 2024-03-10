using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using TMPro;
using Unity.VisualScripting;

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
       // UpdateQuestMenu();
        GameEventsManager.Instance.questEvents.onQuestStateChange += QuestStateChange;
    
        selectedSlot = content.transform.GetComponentInChildren<UISlot>();
        selectedSlot.ChangeAlpha(1f);
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

    private void Update()
    {
        ChangeSelectedSlot(Managers.Input.MoveUI);
        OnSelect();


    }
    private void CreateQuestSlot()
    {
        foreach (UISlot slot in slots) 
            Managers.Pool.Push(slot.gameObject);
        
        slots.Clear();
        
        int i = 0;
        foreach (Quest quest in QuestManager.Instance.QuestDic.Values)
        {
            UISlot slot = Managers.Resource.Instantiate("Prefabs/UI/QuestSlot", content, true).GetComponent<UISlot>();
            slot.transform.SetSiblingIndex(i++);
            slot.SlotType = SlotType.QuestMenu;
            slots.Add(slot);
            UpdateSlot(slot, quest);
        }
    }
    
    public void UpdateSlot(UISlot slot, Quest quest)
    {
        slot.Texts["NameText"].text = ($"{quest.questInfo.questName}");
    }
   
    private void QuestStateChange(Quest quest)
    {
        SetQuestInfo(quest);
    }

    private void OnSelect()
    {
        string qName = selectedSlot.Texts["NameText"].text;
        foreach (Quest q in QuestManager.Instance.QuestDic.Values)
        {
            if(q.questInfo.questName == qName)
            {
                SetQuestInfo(q);
            }
        }
    }

    //Instruction�� ���� ������
    private void SetQuestInfo(Quest quest)
    {
        // quest name
      
        texts["NameText"].text = quest.questInfo.questName;

        // status
        texts["DescriptionText"].text =
            ($"����Ʈ ���� :        {quest.questInfo.description}\n\n " +
            $"�ʿ䷹�� :            {quest.questInfo.requirementPlayerLevel}\n\n" +
            $"�Ϸ���� ���� ����Ʈ : {quest.questInfo.questStepPrefabs.Length}\n\n" +
            $"����Ʈ ���� :         {quest.state.ToString()} \n");
        //foreach (QuestInfoSo prerequisiteQuestInfo in quest.questInfo.questPrerequisites)
        //{
        //    texts["DescriptionText"].text += prerequisiteQuestInfo.questName + "\n";
        //}

        // rewards
        texts["GoldLabelText"].text = ($"{quest.questInfo.goldReward}");
        texts["ExpLabelText"].text = ($"{quest.questInfo.expReward}");
    }
    
    public void ChangeSelectedSlot(float value)
    {
        int i = slots.IndexOf(selectedSlot);
       

        if (i == -1)
            return;
        
        
        if (value > 0)
        {
            selectedSlot.ChangeAlpha(0.2f);
            selectedSlot = slots[(i + 1) % slots.Count];
        }
        else if (value < 0)
        {
            selectedSlot.ChangeAlpha(0.2f);
            selectedSlot = slots[i - 1 < 0 ? slots.Count - 1 : i - 1];
        }
        else
            return;
        
        selectedSlot.ChangeAlpha(1f);
        
    }
}
