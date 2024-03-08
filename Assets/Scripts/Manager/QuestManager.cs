using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using QuestState = Define.QuestState;

public class QuestManager : MonoBehaviour
{
    public static QuestManager Instance { get; private set; }

    public Dictionary<string, Quest> questDic = new();

    public Dictionary<string, Quest> QuestDic { get => questDic; set => questDic = value; }

    private int currentPlayerLevel = 1;

    [Header("Config")]
    public bool loadQuestState = false;

    private void Awake()
    {
        questDic = CreateQuestDic();
        if (Instance != null)
        {
            Debug.LogError("Found more than one Game Events Manager in the scene.");
        }
        Instance = this;

    }

    private void Start()
    {
        //Broadcast the initial state of all quests on startup
        foreach (Quest quest in questDic.Values)
        {
            //initialize any loaded quest steps
            if (quest.state == QuestState.InProgress)
            {
                quest.InstantiateCurrentQuestStep(this.transform);
            }
            // broadcast the initial state of all quest on startup
            GameEventsManager.Instance.questEvents.QuestStateChange(quest);
        }
        GameEventsManager.Instance.questEvents.onStartQuest += StartQuest;
        GameEventsManager.Instance.questEvents.onAdvanceQuestStep += AdvanceQuest;
        GameEventsManager.Instance.questEvents.onCompleteQuest += CompleteQuest;

        GameEventsManager.Instance.questEvents.onQuestStepStateChange += QuestStepStateChange;

        //TODO: player level changed method and then add
        GameEventsManager.Instance.playerEvents.onPlayerLevelChanged += PlayerLevelChanged;
    }
    private void OnEnable()
    {

    }

    private void OnDisable()
    {
        GameEventsManager.Instance.questEvents.onStartQuest -= StartQuest;
        GameEventsManager.Instance.questEvents.onAdvanceQuestStep -= AdvanceQuest;
        GameEventsManager.Instance.questEvents.onCompleteQuest -= CompleteQuest;

        GameEventsManager.Instance.questEvents.onQuestStepStateChange -= QuestStepStateChange;

        GameEventsManager.Instance.playerEvents.onPlayerLevelChanged -= PlayerLevelChanged;
    }

    private void Update()
    {
        //TODO: Player level has to be subscribed onChanged & onAwake through GameEventsManager.Instance.playerEvents
        // loop through ALL quests
        foreach (Quest quest in questDic.Values)
        {
            // if we're now meeting the requirements, switch over to the CAN_START state
            if (quest.state == QuestState.RequiredNotMet && CheckRequirementsMet(quest))
            {
                ChangeQuestState(quest.questInfo.id, QuestState.CanStart);
            }
        }
    }
    private void OnApplicationQuit()
    {
        foreach (Quest quest in questDic.Values)
        {
            SaveQuest(quest);
            //QuestData questData = quest.GetQuestData();
            //Debug.Log($"State : {questData.state}");
            //Debug.Log($"index : {questData.questStepIndex}");
            //foreach (QuestStepState stepState in questData.questStepStates)
            //{
            //    Debug.Log($"StepState : {stepState.state}");
            //}
        }

    }

    private Dictionary<string, Quest> CreateQuestDic()
    {
        //Loads all QuestInfoSo SOs under the Asset/Resources/ScriptableObject/Quest
        QuestInfoSo[] allQuest = Resources.LoadAll<QuestInfoSo>("ScriptableObject/Quest");
        //Create the  quest map ID to QuestDic
        Dictionary<string, Quest> idToQuestDic = new();
        foreach (QuestInfoSo questInfoSo in allQuest)
        {
            if (idToQuestDic.ContainsKey(questInfoSo.id))
            {
                Debug.LogWarning("Duplicate ID found when creating quest map: " + questInfoSo.id);
            }
            idToQuestDic.Add(questInfoSo.id, LoadQuest(questInfoSo));

            Debug.Log($"Quest : {questInfoSo.questName} Added in Dictionary Successfully");
        }
        return idToQuestDic;
    }

    private bool CheckRequirementsMet(Quest quest)
    {
        bool meetsRequirement = true;
        if (currentPlayerLevel < quest.questInfo.requirementPlayerLevel)
        {
            meetsRequirement = false;
        }

        //Check quest any other prerequisites for completion
        foreach (QuestInfoSo qiSO in quest.questInfo.questPrerequisites)
        {
            if (GetQuestByID(qiSO.id).state != QuestState.Finished)
            {
                meetsRequirement = false;
            }
        }

        return meetsRequirement;
    }


    //플레이어의 레벨이 변경될때마다 호출
    private void PlayerLevelChanged(int level)
    {
        currentPlayerLevel = level;
    }

    //퀘스트 상태 변경
    private void ChangeQuestState(string id, QuestState state)
    {
        Quest quest = GetQuestByID(id);
        quest.state = state;
        GameEventsManager.Instance.questEvents.QuestStateChange(quest);
    }

    private Quest GetQuestByID(string id)
    {
        Quest quest = questDic[id];
        if (quest == null)
        {
            Debug.LogError($"ID not found in the quest Dictionary : {id}");
        }
        return quest;
    }

    private void StartQuest(string id)
    {
        Quest quest = GetQuestByID(id);
        quest.InstantiateCurrentQuestStep(this.transform);
        ChangeQuestState(id, QuestState.InProgress);

    }
    private void AdvanceQuest(string id)
    {
        Quest quest = GetQuestByID(id);

        //move on to the next step
        quest.MoveToNextStep();

        //if there are more steps, instantiate the next one
        if (quest.CurrentStepExists())
        {
            quest.InstantiateCurrentQuestStep(this.transform);
        }
        else
        {
            ChangeQuestState(quest.questInfo.id, QuestState.CanFinish);
        }

    }
    private void CompleteQuest(string id)
    {
        Quest quest = GetQuestByID(id);
        ClaimRewards(quest);
        ChangeQuestState(quest.questInfo.id, QuestState.Finished);

    }

    private void ClaimRewards(Quest quest)
    {
        //TODO: 보상 로직이 달라지면 바꿀것
        GameEventsManager.Instance.goldEvents.GoldGained(quest.questInfo.goldReward);
        GameEventsManager.Instance.playerEvents.ExperienceGained(quest.questInfo.expReward);
    }

    private void QuestStepStateChange(string id, int stepIndex, QuestStepState questStepState)
    {
        Quest quest = GetQuestByID(id);
        quest.StoreQuestStepState(questStepState, stepIndex);
        ChangeQuestState(id, quest.state);
    }
    private void SaveQuest(Quest quest)
    {
        try
        {
            QuestData questData = quest.GetQuestData();
            // serialize using JsonUtility, but use whatever you want here (like JSON.NET)
            string serializedData = JsonUtility.ToJson(questData);

            // instead of Saving in PlayerPrefs, use an actual Save & Load system and write to a file, the cloud, etc..
            PlayerPrefs.SetString(quest.questInfo.id, serializedData);
            Debug.Log(serializedData);
        }
        catch (System.Exception e)
        {
            Debug.LogError($"Failed to save quest with id : {quest.questInfo.id}, {e}");
        }
    }

    private Quest LoadQuest(QuestInfoSo questInfo)
    {
        Quest quest = null;
        try
        {
            // load quest from saved data
            if (PlayerPrefs.HasKey(questInfo.id) && loadQuestState)
            {
                string serializedData = PlayerPrefs.GetString(questInfo.id);
                QuestData questData = JsonUtility.FromJson<QuestData>(serializedData);
                quest = new Quest(questInfo, questData.state, questData.questStepIndex, questData.questStepStates);
            }
            // otherwise, initialize a new quest
            else
            {
                quest = new Quest(questInfo);
            }
        }
        catch (System.Exception e)
        {
            Debug.LogError($"Failed to load quest with id  + {quest.questInfo.id}:  {e}");
        }
        return quest;
    }
}