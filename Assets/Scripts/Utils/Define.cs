using System;

public class Define
{
    // ���(const)
    // ������(Enum)
    // ����

    // �⺻ ȭ�� ������ �ּ� ��
    public const string DefaultArrowDataPath = "ScriptableObject/Item/Arrow/Arrow";
    // ������ ������ �ּ� ��
    public const string RecipeDataPath = "ScriptableObject/Recipe/";

    public const string questDataPath = "ScriptableObject/Quest/";
    
    // Env ���� �ð� : ������ * �ð�
    public const int GrowthTime = 60 * 10;

    public enum SceneType
    {
        TitleScene,     // �κ� ��
        LoadingScene,   // �ε� ��
        GameScene,      // ���� ��
    }
    
    // ������
    public enum ItemType
    {
        None,           //
        Arrow,          // ȭ�� ������
        Consumption,    // �Ҹ� ������
        Ingredients,    // ��� ������
        Etc
    }
    
    // ȭ�� �Ӽ�
    public enum AttributeType
    {
        Default,           // �⺻
        Bomb,           // ��ź - �ٸ�(�ϴܺ�) ���� Ÿ�ݽ� �̵� ����, ��(��ܺ�) ���� Ÿ�ݽ� ���� ����
        Electric,       // ���� - ��� ���� ���� Ÿ�ݽ� �Ͻ� ����
        Fire,           // �� - ��Ʈ ������, ������ ���� ���� ���� ����
        Glue,            // �������� - �ٸ�(�ϴܺ�) ���� Ÿ�ݽ� �̵��ӵ� ����, ��(��ܺ�) ���� Ÿ�ݽ� ���ݼӵ� ���� 
        Light,          // �� - �� ���� Ÿ�ݽ� ���� �ð����� ���� Ÿ�� ��ħ
        Poison,         // �� - ��Ʈ ������, ������ ���� ���� ���� ����
    }
    
    // �Ĺ� Ÿ��
    public enum FarmingType
    {
        None,           // �⺻
        Gathering,      // ä��
        Felling,        // ����
        Mining,         // ä��
        Dismantling     // ����(���� ä��)
    }
    
    // Moose State
    public enum MooseState
    {
        Idle,
        Patrol,
        Run,
        TakeAttack,
        Trace,
        Attack,
        Dead,
    }
    
    public enum BearState
    {
        Idle,
        Think,
        Trace,
        Rush,
        Prowl,
        Attack,
        Roar,
        Dead,
    }
    
    public enum MerchantState
    {
        Idle,
        Wander,
        RunAway,
        Interact,
    }

    public enum Direction
    {
        Up,
        Down,
        Left,
        Right
    }

    public enum QuestState
    {
        RequiredNotMet,
        CanStart,
        InProgress,
        CanFinish,
        Finished
    
    }

}