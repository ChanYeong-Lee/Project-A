using System;

public class Define
{
    // ���(const)
    // ������(Enum)
    // ����

    // ������ ������ �ּ� ��
    public const string RecipeDataPath = "ScriptableObject/Recipe/";
    
    // Env ���� �ð� : ������ * �ð�
    public const int GrowthTime = 60 * 10;

    public enum SceneType
    {
        LobbyScene,     // �κ� ��
        GameScene,      // ���� ��
    }
    
    // ������
    public enum ItemType
    {
        None,           //
        Equipment,      // ��� ������
        Consumption,    // �Ҹ� ������
        Etc
    }
    
    // ȭ�� �Ӽ�
    public enum AttributeType
    {
        None,           // �⺻
        Light,          // �� - �� ���� Ÿ�ݽ� ���� �ð����� ���� Ÿ�� ��ħ
        Bomb,           // ��ź - �ٸ�(�ϴܺ�) ���� Ÿ�ݽ� �̵� ����, ��(��ܺ�) ���� Ÿ�ݽ� ���� ����
        Glue,            // �������� - �ٸ�(�ϴܺ�) ���� Ÿ�ݽ� �̵��ӵ� ����, ��(��ܺ�) ���� Ÿ�ݽ� ���ݼӵ� ���� 
        Poison,         // �� - ��Ʈ ������, ������ ���� ���� ���� ����
        Fire,           // �� - ��Ʈ ������, ������ ���� ���� ���� ����
        Electric,       // ���� - ��� ���� ���� Ÿ�ݽ� �Ͻ� ����
        Etc
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
    }
    public enum MerchantState
    {
        Idle,
        Wander,
        RunAway,
        Interact,
    }

}